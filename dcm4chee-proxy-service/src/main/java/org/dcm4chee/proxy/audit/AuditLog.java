/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is part of dcm4che, an implementation of DICOM(TM) in
 * Java(TM), hosted at https://github.com/gunterze/dcm4che.
 *
 * The Initial Developer of the Original Code is
 * Agfa Healthcare.
 * Portions created by the Initial Developer are Copyright (C) 2011
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * See @authors listed below
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

/**
 * @author Michael Backhaus <michael.backhaus@agfa.com>
 */
package org.dcm4chee.proxy.audit;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

import org.dcm4che.util.SafeClose;
import org.dcm4chee.proxy.conf.ProxyApplicationEntity;
import org.dcm4chee.proxy.conf.ProxyDevice;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Michael Backhaus <michael.backhaus@agfa.com>
 */
public class AuditLog {

    protected static final Logger LOG = LoggerFactory.getLogger(AuditLog.class);

    ProxyApplicationEntity ae;

    public void writeLog(ProxyApplicationEntity ae) {
        this.ae = ae;
        for (String calledAET : ae.getAuditDirectoryPath().list()) {
            File calledAETDir = new File(ae.getAuditDirectoryPath(), calledAET);
            scanCalledAETDir(calledAETDir);
        }
    }

    private void scanCalledAETDir(File calledAETDir) {
        for (String callingAET : calledAETDir.list()) {
            File callingAETDir = new File(calledAETDir.getPath(), callingAET);
            for (String studyIUID : callingAETDir.list()) {
                File studyIUIDDir = new File(callingAETDir.getPath(), studyIUID);
                scanStudyDir(studyIUIDDir);
            }
        }
    }

    private void scanStudyDir(final File studyIUIDDir) {
        ae.getDevice().execute(new Runnable() {
            @Override
            public void run() {
                writeLog(studyIUIDDir);
            }
        });
    }

    private void writeLog(File studyIUIDDir) {
        String separator = System.getProperty("file.separator");
        File startLog = new File(studyIUIDDir + separator + "start.log");
        long lastModified = startLog.lastModified();
        long now = System.currentTimeMillis();
        if (!(now > lastModified + ((ProxyDevice) ae.getDevice()).getSchedulerInterval() * 1000 * 2))
            return;

        File[] logFiles = studyIUIDDir.listFiles(fileFilter());
        if (logFiles != null && logFiles.length > 1) {
            Log log = new Log();
            log.files = logFiles.length;
            for (File file : logFiles) {
                readProperties(file, log);
            }
            float mb = log.totalSize / 1048576F;
            float time = (log.t2 - log.t1) / 1000F;
            String path = studyIUIDDir.getPath();
            String studyIUID = path.substring(path.lastIndexOf(separator)+1);
            path = path.substring(0, path.lastIndexOf(separator));
            String callingAET = path.substring(path.lastIndexOf(separator)+1);
            path = path.substring(0, path.lastIndexOf(separator));
            String calledAET = path.substring(path.lastIndexOf(separator)+1);
            LOG.info("Sent {} {} (={}MB) of study {} with SOPClassUIDs {} from {} to {} in {}s (={}MB/s)",
                    new Object[] {
                            log.files - 1,
                            ((log.files - 1) > 1) ? "objects" : "object",
                            mb,
                            studyIUID, 
                            Arrays.toString(log.sopclassuid.toArray()), 
                            callingAET, 
                            calledAET, 
                            time, 
                            (log.totalSize / 1048576F) / time});
            for (File file : logFiles)
                if (!file.delete())
                    LOG.debug("Failed to delete " + file);
            if (!studyIUIDDir.delete())
                LOG.debug("Failed to delete " + studyIUIDDir);
        }
    }

    private void readProperties(File file, Log log) {
        Properties prop = new Properties();
        try {
            final FileInputStream inStream = new FileInputStream(file);
            prop.load(inStream);
            if (!file.getPath().endsWith("start.log")) {
                log.totalSize = log.totalSize + Long.parseLong(prop.getProperty("size"));
                log.sopclassuid.add(prop.getProperty("SOPClassUID"));
            }
            long time = Long.parseLong(prop.getProperty("time"));
            SafeClose.close(inStream);
            log.t1 = (log.t1 == 0 || log.t1 > time) ? time : log.t1;
            log.t2 = (log.t2 == 0 || log.t2 < time) ? time : log.t2;
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private FileFilter fileFilter() {
        return new FileFilter() {

            @Override
            public boolean accept(File pathname) {
                if (pathname.getPath().endsWith(".log"))
                    return true;
                return false;
            }
        };
    }

    private class Log {
        private long totalSize;
        private int files;
        private long t1, t2;
        private Set<String> sopclassuid = new HashSet<String>();
    }
}
