<?xml version="1.0" encoding="UTF-8"?>
<!-- ===== BEGIN LICENSE BLOCK =====
    
    Version: MPL 1.1/GPL 2.0/LGPL 2.1
    
    The contents of this file are subject to the Mozilla Public License Version
    1.1 (the "License"); you may not use this file except in compliance with
    the License. You may obtain a copy of the License at
    http://www.mozilla.org/MPL/
    
    Software distributed under the License is distributed on an "AS IS" basis,
    WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
    for the specific language governing rights and limitations under the
    License.
    
    The Original Code is part of dcm4che, an implementation of DICOM(TM) in
    Java(TM), hosted at https://github.com/dcm4che.
    
    The Initial Developer of the Original Code is
    Agfa Healthcare.
    Portions created by the Initial Developer are Copyright (C) 2013
    the Initial Developer. All Rights Reserved.
    
    Contributor(s):
    Michael Backhaus <michael.backhaus@agfa.com>
    
    Alternatively, the contents of this file may be used under the terms of
    either the GNU General Public License Version 2 or later (the "GPL"), or
    the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
    in which case the provisions of the GPL or the LGPL are applicable instead
    of those above. If you wish to allow use of your version of this file only
    under the terms of either the GPL or the LGPL, and not to allow others to
    use your version of this file under the terms of the MPL, indicate your
    decision by deleting the provisions above and replace them with the notice
    and other provisions required by the GPL or the LGPL. If you do not delete
    the provisions above, a recipient may use your version of this file under
    the terms of any one of the MPL, the GPL or the LGPL.
    
    ===== END LICENSE BLOCK ===== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xml:space="preserve">
  <!-- Required Parameters (will be set by Proxy) -->
  <xsl:param name="IrradiationEventUID" />
  <xsl:param name="DeviceObserverUID" />
  <xsl:param name="PerfomedProcedureStepSOPInstanceUID" />
  <xsl:template match="/">
    <!-- IMPORTANT: 
    Configure 
    * 'Procedure Intent', 
    * 'Irradiation Event Type' 
    * 'Acquisition Plane' 
    according to Modality and Protocols. -->
    <NativeDicomModel xml-space="preserved">
      <DicomAttribute keyword="SOPClassUID" tag="00080016" vr="UI">
        <Value number="1">1.2.840.10008.5.1.4.1.1.88.67</Value>
      </DicomAttribute>
      <!-- SOPInstanceUID will be generated and set by code using this xsl -->
      <DicomAttribute keyword="StudyDate" tag="00080020" vr="DA">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400244']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="ContentDate" tag="00080023" vr="DA">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400244']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="StudyTime" tag="00080030" vr="TM">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400245']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="ContentTime" tag="00080033" vr="TM">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400245']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="AccessionNumber" tag="00080050" vr="SH">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400270']/Item[1]/DicomAttribute[@tag='00080050']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="Modality" tag="00080060" vr="CS">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00080060']/Value" />
        </Value>
      </DicomAttribute>
      <!-- Manually set Manufacturer if not included in MPPS -->
      <DicomAttribute keyword="Manufacturer" tag="00080070" vr="LO">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00080070']/Value" />
        </Value>
      </DicomAttribute>
      <!-- Manually set ManufacturerModelName if not included in MPPS -->
      <DicomAttribute keyword="ManufacturerModelName" tag="00081090" vr="LO">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00081090']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="ReferringPhysicianName" tag="00080090" vr="PN">
        <xsl:copy-of select="/NativeDicomModel/DicomAttribute[@tag='00080090']/PersonName[1]" />
      </DicomAttribute>
      <DicomAttribute keyword="ReferencedPerformedProcedureStepSequence" tag="00081111" vr="SQ">
        <xsl:copy-of select="/NativeDicomModel/DicomAttribute[@tag='00081111']/Item[1]" />
      </DicomAttribute>
      <DicomAttribute keyword="PatientName" tag="00100010" vr="PN">
        <xsl:copy-of select="/NativeDicomModel/DicomAttribute[@tag='00100010']/PersonName[1]" />
      </DicomAttribute>
      <DicomAttribute keyword="PatientID" tag="00100020" vr="LO">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00100020']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="PatientBirthDate" tag="00100030" vr="DA">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00100030']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="PatientSex" tag="00100040" vr="CS">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00100040']/Value" />
        </Value>
      </DicomAttribute>
      <!-- Manually set DeviceSerialNumber if not included in MPPS -->
      <DicomAttribute keyword="DeviceSerialNumber" tag="00181000" vr="LO">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00181000']/Value" />
        </Value>
      </DicomAttribute>
      <!-- Manually set SoftwareVersions if not included in MPPS -->
      <DicomAttribute keyword="SoftwareVersions" tag="00181020" vr="LO">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00181020']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="StudyInstanceUID" tag="0020000D" vr="UI">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400270']/Item[1]/DicomAttribute[@tag='0020000D']/Value" />
        </Value>
      </DicomAttribute>
      <DicomAttribute keyword="StudyID" tag="00200010" vr="SH">
        <Value number="1">
          <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400270']/Item[1]/DicomAttribute[@tag='00200010']/Value" />
        </Value>
      </DicomAttribute>
      <!-- SeriesInstanceUID is generated and set in Java method using this xsl -->
      <DicomAttribute keyword="SeriesNumber" tag="00200011" vr="IS">
        <Value number="1">1</Value>
      </DicomAttribute>
      <DicomAttribute keyword="InstanceNumber" tag="00200013" vr="SH">
        <Value number="1">1</Value>
      </DicomAttribute>
      <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
        <Value number="1">CONTAINER</Value>
      </DicomAttribute>
      <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
        <Item number="1">
          <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
            <Value number="1">113701</Value>
          </DicomAttribute>
          <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
            <Value number="1">DCM</Value>
          </DicomAttribute>
          <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
            <Value number="1">X-Ray Radiation Dose Report</Value>
          </DicomAttribute>
        </Item>
      </DicomAttribute>
      <DicomAttribute keyword="ContinuityOfContent" tag="0040A050" vr="CS">
        <Value number="1">SEPARATE</Value>
      </DicomAttribute>
      <DicomAttribute keyword="CompletionFlag" tag="0040A491" vr="CS">
        <Value number="1">PARTIAL</Value>
      </DicomAttribute>
      <DicomAttribute keyword="VerificationFlag" tag="0040A493" vr="CS">
        <Value number="1">UNVERIFIED</Value>
      </DicomAttribute>
      <!-- TID 10001 Projection X-Ray Radiation Dose -->
      <DicomAttribute keyword="ContentTemplateSequence" tag="0040A504" vr="SQ">
        <Item number="1">
          <DicomAttribute keyword="MappingResource" tag="00080105" vr="CS">
            <Value number="1">DCMR</Value>
          </DicomAttribute>
          <DicomAttribute keyword="TemplateIdentifier" tag="0040DB00" vr="CS">
            <Value number="1">10006</Value>
          </DicomAttribute>
        </Item>
      </DicomAttribute>
      <DicomAttribute keyword="ContentSequence" tag="0040A730" vr="SQ">
        <Item number="1">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">HAS CONCEPT MOD</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">121058</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Procedure reported</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113704</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Projection X-Ray</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ContentSequence" tag="0040A730" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">HAS CONCEPT MOD</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">G-C0E8</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">SRT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Has Intent</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">R-408C3</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">SRT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Diagnostic Intent</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <!-- Other Procedure Intent -->
              <!--  
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">R-41531</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">SRT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Therapeutic Intent</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">R-002E9</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">SRT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Combined Diagnostic and Therapeutic Procedure</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              -->
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="2">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">122142</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Acquisition Device Type</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113957</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Fluoroscopy-Guided Projection Radiography System</Value>
              </DicomAttribute>
            </Item>
            <!-- 
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113958</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Integrated Projection Radiography System</Value>
              </DicomAttribute>
            </Item>
            -->
            <!-- 
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113959</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Cassette-based Projection Radiography System</Value>
              </DicomAttribute>
            </Item>
            -->
          </DicomAttribute>
        </Item>
        <Item number="3">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">HAS OBS CONTEXT</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">121005</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Observer Type</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">121007</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Device</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="4">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">HAS OBS CONTEXT</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">UIDREF</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">121012</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Device Observer UID</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="UID" tag="0040A124" vr="UI">
            <Value number="1">
              <xsl:value-of select="$DeviceObserverUID" />
            </Value>
          </DicomAttribute>
        </Item>
        <Item number="5">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">HAS OBS CONTEXT</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113876</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Device Role in Procedure</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">121097</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Recording</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="6">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">HAS OBS CONTEXT</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113705</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Scope of Accumulation</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113016</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Performed Procedure Step</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ContentSequence" tag="0040A730" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">HAS PROPERTIES</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">UIDREF</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">121126</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Performed Procedure Step SOP Instance UID</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="UID" tag="0040A124" vr="UI">
                <Value number="1">
                  <xsl:value-of
                    select="$PerfomedProcedureStepSOPInstanceUID" />
                </Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="7">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113945</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">X-Ray Detector Data Available</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">R-00339</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">SRT</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">No</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="8">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113943</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">X-Ray Source Data Available</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">R-00339</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">SRT</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">No</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="9">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113944</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">X-Ray Mechanical Data Available</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">R-00339</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">SRT</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">No</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <Item number="10">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CONTAINER</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113702</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Accumulated X-Ray Dose Data</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ContinuityOfContent" tag="0040A050" vr="CS">
            <Value number="1">SEPARATE</Value>
          </DicomAttribute>
          <!-- TID 10002 Accumulated X-Ray Dose -->
          <DicomAttribute keyword="ContentSequence" tag="0040A730" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">HAS CONCEPT MOD</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113764</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Acquisition Plane</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113622</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Single Plane</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <!-- Other Acquisition Planes -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113620</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">Plane A</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113621</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">Plane B</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113890</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">All Planes</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
            </Item>
            <!-- TID 10004 -->
            <Item number="2">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">NUM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113722</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Dose Area Product Total</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="MeasuredValueSequence" tag="0040A300" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="MeasurementUnitsCodeSequence" tag="004008EA" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">Gy.m2</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">UCUM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Gy.m2</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="NumericValue" tag="0040A30A" vr="DS">
                    <Value number="1">
                      <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='0018115E']/Value div 100000" />
                    </Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
            </Item>
            <Item number="3">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">NUM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113727</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Acquisition Dose Area Product Total</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="MeasuredValueSequence" tag="0040A300" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="MeasurementUnitsCodeSequence" tag="004008EA"
                    vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">Gy.m2</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102"
                        vr="SH">
                        <Value number="1">UCUM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Gy.m2</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="NumericValue" tag="0040A30A" vr="DS">
                    <Value number="1">
                      <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='0018115E']/Value div 100000" />
                    </Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
            </Item>
            <Item number="4">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">NUM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113855</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Total Acquisition Time</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="MeasuredValueSequence" tag="0040A300" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="MeasurementUnitsCodeSequence" tag="004008EA" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">s</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">UCUM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">s</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="NumericValue" tag="0040A30A" vr="DS">
                    <Value number="1">
                      <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400300']/Value" />
                    </Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
            </Item>
            <Item number="5">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113876</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Device Role in Procedure</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113859</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Irradiating Device</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ContentSequence" tag="0040A730" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                    <Value number="1">HAS PROPERTIES</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                    <Value number="1">TEXT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113877</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Device Name</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="Value" tag="0040A160" vr="UT">
                    <Value number="1">
                        <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00400241']/Value" />
                    </Value>
                  </DicomAttribute>
                </Item>
                <Item number="2">
                  <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                    <Value number="1">HAS PROPERTIES</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                    <Value number="1">TEXT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113878</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Device Manufacturer</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="Value" tag="0040A160" vr="UT">
                    <Value number="1">
                        <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00080070']/Value" />
                    </Value>
                  </DicomAttribute>
                </Item>
                <Item number="3">
                  <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                    <Value number="1">HAS PROPERTIES</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                    <Value number="1">TEXT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113879</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Device Model Name</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="Value" tag="0040A160" vr="UT">
                    <Value number="1">
                      <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00081090']/Value" />
                    </Value>
                  </DicomAttribute>
                </Item>
                <Item number="4">
                  <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                    <Value number="1">HAS PROPERTIES</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                    <Value number="1">TEXT</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113880</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Device Serial Number</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="Value" tag="0040A160" vr="UT">
                    <Value number="1">
                      <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='00081090']/Value" />
                    </Value>
                  </DicomAttribute>
                </Item>
                <Item number="5">
                  <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                    <Value number="1">HAS PROPERTIES</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                    <Value number="1">UIDREF</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">121012</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Device Observer UID</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="UID" tag="0040A124" vr="UI">
                    <Value number="1">
                      <xsl:value-of select="$DeviceObserverUID" />
                    </Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
        <!-- TID 10003 -->
        <Item number="11">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CONTAINER</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113706</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Irradiation Event X-Ray Data</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ContinuityOfContent" tag="0040A050" vr="CS">
            <Value number="1">SEPARATE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ContentSequence" tag="0040A730" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">HAS CONCEPT MOD</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113764</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Acquisition Plane</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113622</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Single Plane</Value>
                  </DicomAttribute>
                </Item>
                <!-- Other Acquisition Planes -->
                <!--
                <Item number="1">
                    <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113620</Value>
                    </DicomAttribute>
                    <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                    </DicomAttribute>
                    <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Plane A</Value>
                    </DicomAttribute>
                </Item>
                -->
                <!--
                <Item number="1">
                    <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113621</Value>
                    </DicomAttribute>
                    <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                    </DicomAttribute>
                    <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Plane B</Value>
                    </DicomAttribute>
                </Item>
                -->
                <!--
                <Item number="1">
                    <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">113890</Value>
                    </DicomAttribute>
                    <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">DCM</Value>
                    </DicomAttribute>
                    <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">All Planes</Value>
                    </DicomAttribute>
                </Item>
                -->
              </DicomAttribute>
            </Item>
            <Item number="2">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">UIDREF</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113769</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Irradiation Event UID</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="UID" tag="0040A124" vr="UI">
                <Value number="1">
                  <xsl:value-of select="$IrradiationEventUID" />
                </Value>
              </DicomAttribute>
            </Item>
            <Item number="3">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">DATETIME</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">111526</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">DateTime Started</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="DateTime" tag="0040A120" vr="DT">
                <Value number="1">
                  <xsl:value-of select="concat(/NativeDicomModel/DicomAttribute[@tag='00400244']/Value, /NativeDicomModel/DicomAttribute[@tag='00400245']/Value)" />
                </Value>
              </DicomAttribute>
            </Item>
            <Item number="4">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113721</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Irradiation Event Type</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113611</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Stationary Acquisition</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <!-- Other Irradiation Event Types -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">P5-0600</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">SRT</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">Fluoroscopy</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113612</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">Stepping Acquisition</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113613</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">Rotational Acquisition</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
			   <DicomAttribute keyword="UID" tag="0040A124" vr="UI">
                <Value number="1">
                  <xsl:value-of select="$IrradiationEventUID" />
                </Value>
              </DicomAttribute>
            </Item>
            <Item number="5">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">123014</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Target Region</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <xsl:choose>
                  <xsl:when test="/NativeDicomModel/DicomAttribute[@tag='00081032']/Item[1]">
                    <xsl:copy-of select="/NativeDicomModel/DicomAttribute[@tag='00081032']/Item[1]" />
                  </xsl:when>
                  <xsl:when test="/NativeDicomModel/DicomAttribute[@tag='00400270']/Item[1]/DicomAttribute[@tag='00400008']/Item[1]">
                    <xsl:copy-of select="/NativeDicomModel/DicomAttribute[@tag='00400270']/Item[1]/DicomAttribute[@tag='00400008']/Item[1]" />
                  </xsl:when>
                  <xsl:otherwise>
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">T-D0010</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">SRT</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Entire body</Value>
                      </DicomAttribute>
                    </Item>
                  </xsl:otherwise>
                </xsl:choose>
              </DicomAttribute>
            </Item>
            <Item number="6">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">NUM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">122130</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Dose Area Product</Value>
                  </DicomAttribute>
				   <DicomAttribute keyword="UID" tag="0040A124" vr="UI">
                <Value number="1">
                  <xsl:value-of select="$IrradiationEventUID" />
                </Value>
              </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="MeasuredValueSequence" tag="0040A300" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="MeasurementUnitsCodeSequence" tag="004008EA" vr="SQ">
                    <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                        <Value number="1">Gy.m2</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                        <Value number="1">UCUM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                        <Value number="1">Gym2</Value>
                      </DicomAttribute>
                    </Item>
                  </DicomAttribute>
                  <DicomAttribute keyword="NumericValue" tag="0040A30A" vr="DS">
                    <Value number="1">
                      <xsl:value-of select="/NativeDicomModel/DicomAttribute[@tag='0018115E']/Value div 100000" />
                    </Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
            </Item>
            <Item number="7">
              <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
                <Value number="1">CONTAINS</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
                <Value number="1">CODE</Value>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113780</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">Reference Point Definition</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                <Item number="1">
                  <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                    <Value number="1">113860</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                    <Value number="1">DCM</Value>
                  </DicomAttribute>
                  <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                    <Value number="1">15cm from Isocenter toward Source</Value>
                  </DicomAttribute>
                </Item>
              </DicomAttribute>
              <!-- Other Reference Point Definition -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113861</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">30cm in Front of Image Input Surface</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113862</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">1cm above Tabletop</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113863</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">30cm above Tabletop</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113864</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">15cm from Table Centerline</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
              <!--
              <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
                  <Item number="1">
                      <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                          <Value number="1">113865</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                          <Value number="1">DCM</Value>
                      </DicomAttribute>
                      <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                          <Value number="1">Entrance exposure to a 4.2 cm breast thickness</Value>
                      </DicomAttribute>
                  </Item>
              </DicomAttribute>
              -->
            </Item>
            <xsl:apply-templates select="/NativeDicomModel/DicomAttribute[@tag='00400340']/Item" />
          </DicomAttribute>
        </Item>
        <Item number="12">
          <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
            <Value number="1">CONTAINS</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
            <Value number="1">CODE</Value>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113854</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">Source of Dose Information</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
          <DicomAttribute keyword="ConceptCodeSequence" tag="0040A168" vr="SQ">
            <Item number="1">
              <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
                <Value number="1">113858</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
                <Value number="1">DCM</Value>
              </DicomAttribute>
              <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
                <Value number="1">MPPS Content</Value>
              </DicomAttribute>
            </Item>
          </DicomAttribute>
        </Item>
      </DicomAttribute>
    </NativeDicomModel>
  </xsl:template>

  <xsl:template name="AcquiredImage" match="Item">
    <Item number="{@number+7}">
      <DicomAttribute keyword="ReferencedSOPSequence" tag="00081199" vr="SQ">
        <Item number="1">
          <DicomAttribute keyword="ReferencedSOPClassUID" tag="00081150" vr="UI">
            <Value number="1">
              <xsl:value-of select="DicomAttribute[@tag='00081140']/Item[1]/DicomAttribute[@tag='00081150']/Value" />
            </Value>
          </DicomAttribute>
          <DicomAttribute keyword="ReferencedSOPInstanceUID" tag="00081155" vr="UI">
            <Value number="1">
              <xsl:value-of select="DicomAttribute[@tag='00081140']/Item[1]/DicomAttribute[@tag='00081155']/Value" />
            </Value>
          </DicomAttribute>
        </Item>
      </DicomAttribute>
      <DicomAttribute keyword="RelationshipType" tag="0040A010" vr="CS">
        <Value number="1">CONTAINS</Value>
      </DicomAttribute>
      <DicomAttribute keyword="ValueType" tag="0040A040" vr="CS">
        <Value number="1">IMAGE</Value>
      </DicomAttribute>
      <DicomAttribute keyword="ConceptNameCodeSequence" tag="0040A043" vr="SQ">
        <Item number="1">
          <DicomAttribute keyword="CodeValue" tag="00080100" vr="SH">
            <Value number="1">113795</Value>
          </DicomAttribute>
          <DicomAttribute keyword="CodingSchemeDesignator" tag="00080102" vr="SH">
            <Value number="1">DCM</Value>
          </DicomAttribute>
          <DicomAttribute keyword="CodeMeaning" tag="00080104" vr="LO">
            <Value number="1">Acquired Image</Value>
          </DicomAttribute>
        </Item>
      </DicomAttribute>
    </Item>
  </xsl:template>
</xsl:stylesheet>
