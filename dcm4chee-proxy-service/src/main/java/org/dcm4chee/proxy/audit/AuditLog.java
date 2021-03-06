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
 * Java(TM), hosted at https://github.com/dcm4che.
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
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

import org.dcm4che3.audit.AuditMessage;
import org.dcm4che3.audit.AuditMessages;
import org.dcm4che3.audit.AuditMessages.EventActionCode;
import org.dcm4che3.audit.AuditMessages.EventID;
import org.dcm4che3.audit.AuditMessages.EventOutcomeIndicator;
import org.dcm4che3.audit.ParticipantObjectDescription;
import org.dcm4che3.audit.SOPClass;
import org.dcm4che3.net.ApplicationEntity;
import org.dcm4che3.net.audit.AuditLogger;
import org.dcm4chee.proxy.common.AuditDirectory;
import org.dcm4chee.proxy.conf.ProxyAEExtension;
import org.dcm4chee.proxy.conf.ProxyDeviceExtension;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Michael Backhaus <michael.backhaus@agfa.com>
 */
public class AuditLog {

    protected static final Logger LOG = LoggerFactory.getLogger(AuditLog.class);

    private final String separator = System.getProperty("file.separator");

    private static AuditLogger logger;

    public AuditLog(AuditLogger logger) {
        AuditLog.logger = logger;
        AuditLogger.setDefaultLogger(logger);
    }

    public void scanLogDir(ApplicationEntity ae) {
        ProxyAEExtension proxyAEE = ae.getAEExtension(ProxyAEExtension.class);
        if (!proxyAEE.isEnableAuditLog())
            return;

        try {
            File failedPath = proxyAEE.getFailedAuditDirectoryPath();
            for (String calledAET : failedPath.list())
                scanCalledAETDir(ae, new File(failedPath, calledAET), AuditDirectory.FAILED);
            File transferredPath = proxyAEE.getTransferredAuditDirectoryPath();
            for (String calledAET : transferredPath.list())
                scanCalledAETDir(ae, new File(transferredPath, calledAET), AuditDirectory.TRANSFERRED);
            File deletePath = proxyAEE.getDeleteAuditDirectoryPath();
            for (String calledAET : deletePath.list())
                scanCalledAETDir(ae, new File(deletePath, calledAET), AuditDirectory.DELETED);
        } catch (IOException e) {
            LOG.error("Error reading from audit log directory: {}", e.getMessage());
            if(LOG.isDebugEnabled())
                e.printStackTrace();
        }
    }

    private void scanCalledAETDir(ApplicationEntity ae, File calledAETDir, AuditDirectory auditDir) {
        for (String callingAET : calledAETDir.list()) {
            File callingAETDir = new File(calledAETDir.getPath(), callingAET);
            for (String studyIUID : callingAETDir.list()) {
                File studyIUIDDir = new File(callingAETDir.getPath(), studyIUID);
                scanStudyDir(ae, studyIUIDDir, auditDir);
            }
        }
    }

    private void scanStudyDir(final ApplicationEntity ae, final File studyIUIDDir, final AuditDirectory auditDir) {
        ae.getDevice().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (auditDir == AuditDirectory.FAILED)
                        checkRetryLog(ae, studyIUIDDir, auditDir);
                    else
                        checkLog(ae, studyIUIDDir, auditDir);
                } catch (IOException e) {
                    LOG.error("Error processing audit log for study dir {}: {}", studyIUIDDir.getPath(), e);
                    if(LOG.isDebugEnabled())
                        e.printStackTrace();
                }
            }
        });
    }

    private void checkRetryLog(ApplicationEntity ae, File studyIUIDDir, AuditDirectory auditDir) throws IOException {
        if (!studyIUIDDir.exists())
            return;

        for (String numRetry : studyIUIDDir.list()) {
            File startLog = new File(studyIUIDDir + separator + numRetry + separator + "start.log");
            long lastModified = startLog.lastModified();
            long now = System.currentTimeMillis();
            ProxyDeviceExtension proxyDev = (ProxyDeviceExtension) ae.getDevice().getDeviceExtension(
                    ProxyDeviceExtension.class);
            if (!(now > lastModified + proxyDev.getSchedulerInterval() * 1000 * 2))
                return;

            writeFailedLogMessage(ae, studyIUIDDir, numRetry, auditDir);
        }
    }

    private void checkLog(ApplicationEntity ae, File studyIUIDDir, AuditDirectory auditDir) throws IOException {
        if (!studyIUIDDir.exists())
            return;

        File startLog = new File(studyIUIDDir + separator + "start.log");
        long lastModified = startLog.lastModified();
        long now = System.currentTimeMillis();
        ProxyDeviceExtension proxyDev = (ProxyDeviceExtension) ae.getDevice().getDeviceExtension(ProxyDeviceExtension.class);
        if (!(now > lastModified + proxyDev.getSchedulerInterval() * 1000 * 2))
            return;

        writeLogMessage(ae, studyIUIDDir, auditDir);
    }

    private void writeLogMessage(ApplicationEntity ae, File studyIUIDDir, AuditDirectory auditDir) throws IOException {
        File[] logFiles = studyIUIDDir.listFiles(fileFilter());
        if (logFiles != null && logFiles.length > 1) {
            Log log = new Log();
            log.files = logFiles.length;
            for (File file : logFiles)
                readProperties(file, log);
            float mb = log.totalSize / 1048576F;
            float time = (log.t2 - log.t1) / 1000F;
            String path = studyIUIDDir.getPath();
            String studyIUID = path.substring(path.lastIndexOf(separator) + 1);
            path = path.substring(0, path.lastIndexOf(separator));
            String callingAET = path.substring(path.lastIndexOf(separator) + 1);
            path = path.substring(0, path.lastIndexOf(separator));
            String calledAET = path.substring(path.lastIndexOf(separator) + 1);
            Calendar timeStamp = new GregorianCalendar();
            timeStamp.setTimeInMillis(log.t2);
            AuditMessage msg = new AuditMessage();
            try {
                switch (auditDir) {
                case TRANSFERRED:
                    writeTransferredServerLogMessage(log, mb, time, studyIUID, callingAET, calledAET);
                    msg = createAuditMessage(ae, log, studyIUID, calledAET, log.hostname, callingAET, timeStamp,
                            EventID.DICOMInstancesTransferred, EventActionCode.Read, EventOutcomeIndicator.Success);
                    break;
                case DELETED:
                    writeDeleteServerLogMessage(log, studyIUID, studyIUIDDir.getPath());
                    msg = createAuditMessage(ae, log, studyIUID, ae.getAETitle(), ae.getConnections().get(0).getHostname(),
                            callingAET, timeStamp, EventID.DICOMInstancesAccessed, EventActionCode.Delete,
                            EventOutcomeIndicator.Success);
                    break;
                default:
                    LOG.error("Unrecognized Audit Directory: " + auditDir.getDirectoryName());
                    break;
                }
                if (LOG.isDebugEnabled())
                    LOG.debug("AuditMessage: " + AuditMessages.toXML(msg));
                logger.write(timeStamp, msg);
            } catch (Exception e) {
                LOG.error("Failed to write audit log message: " + e.getMessage());
                if(LOG.isDebugEnabled())
                    e.printStackTrace();
            }
            boolean deleteStudyDir = deleteLogFiles(logFiles);
            if (deleteStudyDir)
                deleteStudyDir(studyIUIDDir);
        }
    }

    private synchronized void deleteStudyDir(File studyIUIDDir) {
        for (String dir : studyIUIDDir.list()) {
            File subDir = new File(studyIUIDDir + separator + dir);
            if (subDir.listFiles() == null || subDir.listFiles().length > 0)
                return;

            if (subDir.delete())
                LOG.debug("Delete dir " + subDir.getAbsolutePath());
            else
                LOG.error("Failed to delete " + subDir.getAbsolutePath());
        }
        if (studyIUIDDir.list().length == 0) {
            if (studyIUIDDir.delete())
                LOG.debug("Delete dir " + studyIUIDDir.getAbsolutePath());
            else
                LOG.error("Failed to delete " + studyIUIDDir.getAbsolutePath());
        }
    }

    private synchronized boolean deleteLogFiles(File[] logFiles) {
        boolean deleteStudyDir = true;
        for (File file : logFiles) {
            if (file.delete()) 
                LOG.debug("Delete log file " + file.getAbsolutePath());
            else {
                LOG.error("Failed to delete " + file.getAbsolutePath());
                deleteStudyDir = false;
            }
        }
        return deleteStudyDir;
    }

    private void writeFailedLogMessage(ApplicationEntity ae, File studyIUIDDir, String retry, AuditDirectory auditDir) throws IOException {
        File retryDir = new File(studyIUIDDir + separator + retry);
        File[] logFiles = retryDir.listFiles(fileFilter());
        if (logFiles != null && logFiles.length > 1) {
            Log log = new Log();
            log.files = logFiles.length;
            for (File file : logFiles)
                readProperties(file, log);
            String retryPath = retryDir.getPath();
            String numRetry = retryPath.substring(retryPath.lastIndexOf(separator) + 1);
            String studyPath = studyIUIDDir.getPath();
            String studyIUID = studyPath.substring(studyPath.lastIndexOf(separator) + 1);
            String callingAETPath = studyPath.substring(0, studyPath.lastIndexOf(separator));
            String callingAET = callingAETPath.substring(callingAETPath.lastIndexOf(separator) + 1);
            String calledAETPath = callingAETPath.substring(0, callingAETPath.lastIndexOf(separator));
            String calledAET = calledAETPath.substring(calledAETPath.lastIndexOf(separator) + 1);
            Calendar timeStamp = new GregorianCalendar();
            timeStamp.setTimeInMillis(log.t2);
            AuditMessage msg = createAuditMessage(ae, log, studyIUID, calledAET, log.hostname, callingAET, timeStamp,
                    EventID.DICOMInstancesTransferred, EventActionCode.Read, EventOutcomeIndicator.SeriousFailure);
            writeFailedServerLogMessage(log, studyIUID, callingAET, calledAET, numRetry);
            try {
                if (LOG.isDebugEnabled())
                    LOG.debug("AuditMessage: " + AuditMessages.toXML(msg));
                logger.write(timeStamp, msg);
            } catch (Exception e) {
                LOG.error("Failed to write audit log message: ", e);
            }
            boolean deleteStudyDir = deleteLogFiles(logFiles);
            if (deleteStudyDir)
                deleteStudyDir(studyIUIDDir);
        }
    }

    private AuditMessage createAuditMessage(ApplicationEntity ae, Log log, String studyIUID, String destinationAET,
            String destinationHostname, String sourceAET, Calendar timeStamp, EventID eventID, String eventActionCode,
            String eventOutcomeIndicator) {
        AuditMessage msg = new AuditMessage();
        msg.setEventIdentification(AuditMessages.createEventIdentification(
                eventID, 
                eventActionCode, 
                timeStamp, 
                eventOutcomeIndicator, 
                null));
        if (!eventActionCode.equals(EventActionCode.Delete))
            msg.getActiveParticipant().add(AuditMessages.createActiveParticipant(
                    destinationHostname, 
                    AuditMessages.alternativeUserIDForAETitle(destinationAET), 
                    null, 
                    false, 
                    null, 
                    null, 
                    null, 
                    AuditMessages.RoleIDCode.Application));
        msg.getActiveParticipant().add(AuditMessages.createActiveParticipant(
                log.proxyHostname, 
                AuditMessages.alternativeUserIDForAETitle(ae.getAETitle()),
                null, 
                false, 
                null, 
                null, 
                null, 
                AuditMessages.RoleIDCode.Application));
        msg.getActiveParticipant().add(AuditMessages.createActiveParticipant(
                log.hostname, 
                AuditMessages.alternativeUserIDForAETitle(sourceAET), 
                null, 
                true, 
                null, 
                null, 
                null, 
                AuditMessages.RoleIDCode.Application));
        ParticipantObjectDescription pod = new ParticipantObjectDescription();
        for (String sopClassUID : log.sopclassuid) {
            SOPClass sc = new SOPClass();
            sc.setUID(sopClassUID);
            sc.setNumberOfInstances(log.files - 1);
            pod.getSOPClass().add(sc);
        }
        msg.getParticipantObjectIdentification().add(AuditMessages.createParticipantObjectIdentification(
                studyIUID, 
                AuditMessages.ParticipantObjectIDTypeCode.StudyInstanceUID, 
                null, 
                null, 
                AuditMessages.ParticipantObjectTypeCode.SystemObject, 
                AuditMessages.ParticipantObjectTypeCodeRole.Report, 
                null, 
                null, 
                pod));
        msg.getParticipantObjectIdentification().add(AuditMessages.createParticipantObjectIdentification(
                log.patientID,
                AuditMessages.ParticipantObjectIDTypeCode.PatientNumber,
                null,
                null,
                AuditMessages.ParticipantObjectTypeCode.Person,
                AuditMessages.ParticipantObjectTypeCodeRole.Patient,
                null,
                null,
                null));
        msg.getAuditSourceIdentification().add(logger.createAuditSourceIdentification());
        return msg;
    }

    private void writeTransferredServerLogMessage(Log log, float mb, float time, String studyIUID, String callingAET,
            String calledAET) {
        LOG.info("Sent {} {} (={}MB) of study {} with SOPClassUIDs {} from {} to {} in {}s (={}MB/s)",
                new Object[] {  log.files - 1, 
                ((log.files - 1) > 1) ? "objects" : "object", 
                mb, 
                studyIUID,
                Arrays.toString(log.sopclassuid.toArray()), 
                callingAET, 
                calledAET, 
                time,
                (log.totalSize / 1048576F) / time });
    }

    private void writeDeleteServerLogMessage(Log log, String studyIUID, String path) {
        LOG.info("Deleted {} {} of study {} with SOPClassUIDs {} from {}",new Object[] {
                log.files - 1,
                ((log.files - 1) > 1) ? "objects" : "object",
                studyIUID,
                Arrays.toString(log.sopclassuid.toArray()),
                path });
    }

    private void writeFailedServerLogMessage(Log log, String studyIUID, String callingAET, String calledAET, String numRetry) {
        LOG.info("Failed to send {} {} of study {} with SOPClassUIDs {} from {} to {} (Retry {})", new Object[]{
                log.files - 1, 
                ((log.files - 1) > 1) ? "objects" : "object",
                studyIUID,
                Arrays.toString(log.sopclassuid.toArray()),
                callingAET,
                calledAET,
                numRetry
        });
    }

    private void readProperties(File file, Log log) throws IOException {
        Properties prop = new Properties();
        FileInputStream inStream = null;
        try {
            inStream = new FileInputStream(file);
            prop.load(inStream);
            if (!file.getPath().endsWith("start.log")) {
                log.totalSize = log.totalSize + Long.parseLong(prop.getProperty("size"));
                log.sopclassuid.add(prop.getProperty("sop-class-uid"));
            } else {
                log.hostname = prop.getProperty("hostname");
                log.proxyHostname = prop.getProperty("proxy-hostname");
                log.patientID = prop.getProperty("patient-id");
            }
            long time = Long.parseLong(prop.getProperty("time"));
            log.t1 = (log.t1 == 0 || log.t1 > time) ? time : log.t1;
            log.t2 = (log.t2 == 0 || log.t2 < time) ? time : log.t2;
        } catch (IOException e) {
            LOG.error("Error reading properties from {}: {}", new Object[]{file.getPath(), e.getMessage()});
            if(LOG.isDebugEnabled())
                e.printStackTrace();
        } finally {
            inStream.close();
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
        private String patientID;
        private String hostname;
        private String proxyHostname;
        private long totalSize;
        private int files;
        private long t1, t2;
        private Set<String> sopclassuid = new HashSet<String>();
    }
}
