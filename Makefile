#
# AMT Test Programm
# Uses system libraries if possible: openwsman, xerces
# libb64 is not working, use private version

# -DTHW_TRACE include call and paramter tracing for understanding wsman stuff

CC = g++ -std=c++11 -g -fpic -DTHW_TRACE
#LINK_OPTS = -Wl,--verbose

#
# Use System wide openwsman

#OPENWSMAN_CLFAGS = $(shell pkg-config --cflags openwsman++)
#OPENWSMAN_LIBS = $(shell pkg-config --libs openwsman++)
#
# Private openwsman library

OPENWSMAN_CLFAGS = -I$(HOME)/include/openwsman -I$(HOME)/include/openwsman/cpp
OPENWSMAN_LIBS = -L$(HOME)/lib64 -lwsman_clientpp -lwsman_curl_client_transport -lwsman -lwsman_client

XERCES_CFLAGS = $(shell pkg-config --cflags xerces-c)
XERCES_LIBS = $(shell pkg-config --libs xerces-c)


INCLUDE =   $(OPENWSMAN_CLFAGS) -Ilibb64 -Iintel/include -Imof/include -ISyncLib/Include
LIBS =  -L. $(OPENWSMAN_LIBS) $(XERCES_LIBS)

AMTLIB = libamt.so.11

#DEPENDFILE = .depend

%.o: %.cpp
	$(CC) -c $(INCLUDE) -o $@ $<

all: amttest


AMT_OBJECTS = mof/src/CIM_BIOSFeature.o \
		mof/src/AMT_SetupAndConfigurationService.o \
		mof/src/CIM_Role.o \
		mof/src/CIM_IEEE8021xCapabilities.o \
		mof/src/CIM_RedirectionService.o \
		mof/src/AMT_ProvisioningCertificateHash.o \
		mof/src/AMT_8021XProfile.o \
		mof/src/CIM_SharedCredential.o \
		mof/src/CIM_PolicyCondition.o \
		mof/src/CIM_Log.o \
		mof/src/AMT_StateTransitionCondition.o \
		mof/src/AMT_MPSUsernamePassword.o \
		mof/src/AMT_CRL.o \
		mof/src/AMT_EventLogEntry.o \
		mof/src/AMT_EnvironmentDetectionSettingData.o \
		mof/src/IPS_ProvisioningAuditRecord.o \
		mof/src/CIM_ProtocolEndpoint.o \
		mof/src/IPS_AdminProvisioningRecord.o \
		mof/src/CIM_PrivilegeManagementCapabilities.o \
		mof/src/CIM_EnabledLogicalElementCapabilities.o \
		mof/src/CIM_PolicySetInSystem.o \
		mof/src/CIM_MediaAccessDevice.o \
		mof/src/CIM_AuthenticationService.o \
		mof/src/AMT_AgentPresenceInterfacePolicy.o \
		mof/src/CIM_Processor.o \
		mof/src/AMT_NetworkPortDefaultSystemDefensePolicy.o \
		mof/src/CIM_Collection.o \
		mof/src/CIM_StatisticalData.o \
		mof/src/CIM_PowerManagementCapabilities.o \
		mof/src/CIM_PolicyRule.o \
		mof/src/AMT_ThirdPartyDataStorageService.o \
		mof/src/IPS_ManualProvisioningRecord.o \
		mof/src/AMT_RemoteAccessCapabilities.o \
		mof/src/IPS_ProvisioningRecordLog.o \
		mof/src/CIM_EthernetPort.o \
		mof/src/CIM_PhysicalComponent.o \
		mof/src/CIM_FilterCollection.o \
		mof/src/CIM_InstalledSoftwareIdentity.o \
		mof/src/IPS_IPv6PortSettings.o \
		mof/src/CIM_RemoteIdentity.o \
		mof/src/AMT_PCIDevice.o \
		mof/src/AMT_RemoteAccessService.o \
		mof/src/CIM_IEEE8021xSettings.o \
		mof/src/AMT_RemoteAccessPolicyRule.o \
		mof/src/CIM_OrderedComponent.o \
		mof/src/CIM_PolicyAction.o \
		mof/src/CIM_WiFiEndpointCapabilities.o \
		mof/src/CIM_SoftwareFeatureSoftwareElements.o \
		mof/src/CIM_ServiceServiceDependency.o \
		mof/src/CIM_ElementStatisticalData.o \
		mof/src/CIM_CredentialContext.o \
		mof/src/CIM_StorageExtent.o \
		mof/src/AMT_EventManagerService.o \
		mof/src/CIM_LogicalPortCapabilities.o \
		mof/src/CIM_LogManagesRecord.o \
		mof/src/CIM_ElementLocation.o \
		mof/src/CIM_NetworkPort.o \
		mof/src/AMT_AgentPresenceWatchdog.o \
		mof/src/IPS_HostBootReason.o \
		mof/src/CIM_RegisteredProfile.o \
		mof/src/CIM_Job.o \
		mof/src/AMT_TLSProtocolEndpoint.o \
		mof/src/CIM_BootSourceSetting.o \
		mof/src/CIM_PowerManagementService.o \
		mof/src/CIM_RoleBasedManagementCapabilities.o \
		mof/src/CIM_PowerSupply.o \
		mof/src/CIM_RoleLimitedToTarget.o \
		mof/src/CIM_Controller.o \
		mof/src/CIM_Error.o \
		mof/src/CIM_Dependency.o \
		mof/src/CIM_Privilege.o \
		mof/src/CIM_ProcessIndication.o \
		mof/src/AMT_PublicKeyManagementService.o \
		mof/src/CIM_FilterCollectionSubscription.o \
		mof/src/CIM_ManagedSystemElement.o \
		mof/src/AMT_AuthorizationService.o \
		mof/src/AMT_AuditPolicyRule.o \
		mof/src/CIM_AssociatedPowerManagementService.o \
		mof/src/AMT_SystemDefensePolicyInService.o \
		mof/src/AMT_AuditLog.o \
		mof/src/CIM_AssignedIdentity.o \
		mof/src/CIM_KVMRedirectionSAP.o \
		mof/src/CIM_UseOfLog.o \
		mof/src/CIM_RemoteAccessAvailableToElement.o \
		mof/src/CIM_ProvidesServiceToElement.o \
		mof/src/CIM_OwningCollectionElement.o \
		mof/src/IPS_HostIPSettings.o \
		mof/src/CIM_ComputerSystemPackage.o \
		mof/src/CIM_PhysicalElementLocation.o \
		mof/src/CIM_ListenerDestination.o \
		mof/src/CIM_PolicyInSystem.o \
		mof/src/IPS_ScreenSettingData.o \
		mof/src/AMT_TLSCredentialContext.o \
		mof/src/CIM_Sensor.o \
		mof/src/CIM_LogicalPort.o \
		mof/src/CIM_WiFiPortCapabilities.o \
		mof/src/CIM_SettingData.o \
		mof/src/AMT_BootCapabilities.o \
		mof/src/IPS_IderSessionUsingPort.o \
		mof/src/CIM_Service.o \
		mof/src/IPS_LANEndpoint.o \
		mof/src/AMT_SystemDefenseService.o \
		mof/src/AMT_HeuristicPacketFilterInterfacePolicy.o \
		mof/src/AMT_GeneralSettings.o \
		mof/src/CIM_PhysicalElement.o \
		mof/src/CIM_LogicalElement.o \
		mof/src/CIM_ConcreteDependency.o \
		mof/src/CIM_CredentialManagementService.o \
		mof/src/AMT_IPHeadersFilter.o \
		mof/src/CIM_RemotePort.o \
		mof/src/CIM_PolicyRuleInSystem.o \
		mof/src/CIM_SoftwareFeature.o \
		mof/src/AMT_NetworkFilter.o \
		mof/src/IPS_KVMRedirectionSettingData.o \
		mof/src/AMT_ActiveFilterStatistics.o \
		mof/src/AMT_TLSSettingData.o \
		mof/src/AMT_GeneralSystemDefenseCapabilities.o \
		mof/src/CIM_Realizes.o \
		mof/src/AMT_TLSProtocolEndpointCollection.o \
		mof/src/AMT_EndpointAccessControlService.o \
		mof/src/IPS_TLSProvisioningRecord.o \
		mof/src/IPS_KvmSessionUsingPort.o \
		mof/src/AMT_RemoteAccessPolicyAppliesToMPS.o \
		mof/src/CIM_SystemBIOS.o \
		mof/src/CIM_DeviceSAPImplementation.o \
		mof/src/CIM_Watchdog.o \
		mof/src/CIM_Component.o \
		mof/src/CIM_RecordLog.o \
		mof/src/CIM_BIOSElement.o \
		mof/src/CIM_ReferencedProfile.o \
		mof/src/AMT_SystemDefensePolicy.o \
		mof/src/CIM_Policy.o \
		mof/src/IPS_SessionUsingPort.o \
		mof/src/CIM_SystemPackaging.o \
		mof/src/AMT_ComplexFilterEntryBase.o \
		mof/src/AMT_UserInitiatedConnectionService.o \
		mof/src/CIM_MemberOfCollection.o \
		mof/src/CIM_LogicalDevice.o \
		mof/src/AMT_PublicKeyManagementCapabilities.o \
		mof/src/CIM_OwningJobElement.o \
		mof/src/AMT_CryptographicCapabilities.o \
		mof/src/CIM_WiFiEndpointSettings.o \
		mof/src/AMT_AssetTableService.o \
		mof/src/CIM_SystemDevice.o \
		mof/src/CIM_PCIController.o \
		mof/src/CIM_PolicySet.o \
		mof/src/CIM_Credential.o \
		mof/src/AMT_Hdr8021Filter.o \
		mof/src/IPS_SolSessionUsingPort.o \
		mof/src/CIM_Chip.o \
		mof/src/CIM_ElementSettingData.o \
		mof/src/CIM_MessageLog.o \
		mof/src/CIM_RecordForLog.o \
		mof/src/CIM_ManagedCredential.o \
		mof/src/CIM_HostedAccessPoint.o \
		mof/src/CIM_ServiceAccessBySAP.o \
		mof/src/CIM_Card.o \
		mof/src/CIM_SoftwareIdentity.o \
		mof/src/AMT_ThirdPartyDataStorageAdministrationService.o \
		mof/src/CIM_SettingsDefineState.o \
		mof/src/CIM_PhysicalPackage.o \
		mof/src/CIM_AccountManagementCapabilities.o \
		mof/src/CIM_ElementConformsToProfile.o \
		mof/src/AMT_HeuristicPacketFilterStatistics.o \
		mof/src/AMT_FilterEntryBase.o \
		mof/src/IPS_8021xCredentialContext.o \
		mof/src/CIM_ConcreteJob.o \
		mof/src/AMT_RedirectionService.o \
		mof/src/AMT_AgentPresenceCapabilities.o \
		mof/src/IPS_ClientProvisioningRecord.o \
		mof/src/CIM_CoolingDevice.o \
		mof/src/CIM_RemoteServiceAccessPoint.o \
		mof/src/CIM_PhysicalMemory.o \
		mof/src/AMT_NetworkPortSystemDefensePolicy.o \
		mof/src/CIM_ServiceAvailableToElement.o \
		mof/src/CIM_Indication.o \
		mof/src/CIM_ServiceSAPDependency.o \
		mof/src/CIM_LogEntry.o \
		mof/src/CIM_ListenerDestinationWSManagement.o \
		mof/src/AMT_AgentPresenceWatchdogAction.o \
		mof/src/AMT_EventSubscriber.o \
		mof/src/CIM_BootConfigSetting.o \
		mof/src/CIM_ComputerSystem.o \
		mof/src/AMT_PETFilterForTarget.o \
		mof/src/AMT_HeuristicPacketFilterSettings.o \
		mof/src/CIM_WiFiPort.o \
		mof/src/AMT_KerberosSettingData.o \
		mof/src/CIM_IndicationService.o \
		mof/src/CIM_ServiceAffectsElement.o \
		mof/src/CIM_Chassis.o \
		mof/src/CIM_WiFiEndpoint.o \
		mof/src/CIM_AuthorizedPrivilege.o \
		mof/src/CIM_EnabledLogicalElement.o \
		mof/src/CIM_SAPAvailableForElement.o \
		mof/src/CIM_PolicySetAppliesToElement.o \
		mof/src/CIM_Memory.o \
		mof/src/AMT_WebUIService.o \
		mof/src/AMT_PETCapabilities.o \
		mof/src/CIM_AccountManagementService.o \
		mof/src/CIM_AdminDomain.o \
		mof/src/AMT_WiFiPortConfigurationService.o \
		mof/src/CIM_AlertIndication.o \
		mof/src/CIM_PhysicalFrame.o \
		mof/src/CIM_ConcreteComponent.o \
		mof/src/AMT_TimeSynchronizationService.o \
		mof/src/CIM_HostedService.o \
		mof/src/AMT_PublicPrivateKeyPair.o \
		mof/src/CIM_BIOSFeatureBIOSElements.o \
		mof/src/CIM_AuthorizationService.o \
		mof/src/CIM_NetworkPortCapabilities.o \
		mof/src/AMT_EACCredentialContext.o \
		mof/src/AMT_SystemPowerScheme.o \
		mof/src/IPS_AlarmClockOccurrence.o \
		mof/src/CIM_SecurityService.o \
		mof/src/AMT_InterfacePolicy.o \
		mof/src/AMT_AgentPresenceService.o \
		mof/src/CIM_PhysicalConnector.o \
		mof/src/CIM_PrivilegeManagementService.o \
		mof/src/IPS_SecIOService.o \
		mof/src/IPS_HostBasedSetupService.o \
		mof/src/CIM_BootService.o \
		mof/src/CIM_System.o \
		mof/src/AMT_PublicKeyCertificate.o \
		mof/src/CIM_LANEndpoint.o \
		mof/src/CIM_ManagedElement.o \
		mof/src/AMT_AssetTable.o \
		mof/src/AMT_EthernetPortSettings.o \
		mof/src/CIM_ServiceAccessPoint.o \
		mof/src/CIM_AccountOnSystem.o \
		mof/src/IPS_IEEE8021xSettings.o \
		mof/src/AMT_FilterInSystemDefensePolicy.o \
		mof/src/CIM_Location.o \
		mof/src/CIM_SoftwareElement.o \
		mof/src/CIM_Fan.o \
		mof/src/AMT_MessageLog.o \
		mof/src/AMT_BootSettingData.o \
		mof/src/IPS_OptInService.o \
		mof/src/AMT_ManagementPresenceRemoteSAP.o \
		mof/src/CIM_RoleBasedAuthorizationService.o \
		mof/src/AMT_TrapTargetForService.o \
		mof/src/AMT_RemoteAccessCredentialContext.o \
		mof/src/CIM_Account.o \
		mof/src/AMT_NetworkPortSystemDefenseCapabilities.o \
		mof/src/CIM_Capabilities.o \
		mof/src/AMT_8021xCredentialContext.o \
		mof/src/AMT_SNMPEventSubscriber.o \
		mof/src/CIM_BootSettingData.o \
		mof/src/CIM_Identity.o \
		mof/src/AMT_PETFilterSetting.o \
		mof/src/CIM_HostedDependency.o \
		mof/src/CIM_ElementSoftwareIdentity.o \
		mof/src/IPS_RasSessionUsingPort.o \
		mof/src/CIM_ElementCapabilities.o \
		mof/src/CIM_SystemComponent.o \
		mof/src/CIM_NetworkPortConfigurationService.o \
		mof/src/CIM_AbstractIndicationSubscription.o \
		mof/src/AMT_EnvironmentDetectionInterfacePolicy.o \
		mof/src/AMT_AlarmClockService.o \
		mof/src/IPS_WatchDogAction.o \
		mof/src/IPS_PowerManagementService.o \
		mof/src/CIM_AssociatedPrivilege.o \
		mof/src/IPS_ScreenConfigurationService.o \
		mof/src/IPS_PowerManagementCapabilities.o \
		mof/src/CimClassFactoryAutoGenerated.o
		

INTEL_OBJECTS = intel/src/CimAnonymous.o \
		intel/src/CimBase.o \
		intel/src/CimTypedUtils.o \
		intel/src/CimClassFactory.o \
		intel/src/CimDateTime.o \
		intel/src/CimException.o \
		intel/src/CimObject.o \
		intel/src/CimReference.o \
		intel/src/CimSerializer.o \
		intel/src/CimData.o \
		intel/src/CimUtils.o \
		intel/src/CimWsman.o \
		intel/src/CimOpenWsmanClient.o \
		intel/src/XMLUtils_XRCS.o
		

SYNCLIB_OBJECTS = SyncLib/src/EventLinux.o \
		  SyncLib/src/RWLock.o \
		  SyncLib/src/SemaphoreLinux.o \
		  SyncLib/src/ThreadLinux.o \
		  SyncLib/src/Timer.o \
		  SyncLib/src/TimerManager.o 

OBJECTS = test.o 

b64 = libb64/cdecode.o libb64/cencode.o

$(AMTLIB): $(AMT_OBJECTS) $(INTEL_OBJECTS) $(b64) $(SYNCLIB_OBJECTS)
	$(CC) -shared -Wl,-soname,$(AMTLIB) -o $(AMTLIB) $(AMT_OBJECTS) $(INTEL_OBJECTS) $(b64) $(SYNCLIB_OBJECTS)
	ln -fs $(AMTLIB) libamt.so
	touch libamt.so


amttest: $(AMTLIB) $(OBJECTS)
	$(CC) $(LINK_OPTS) -o amttest  $(OBJECTS) -lamt $(LIBS)

.PHONY:
clean:
		-\rm $(OBJECTS)
		-\rm $(AMT_OBJECTS) 
		-\rm $(INTEL_OBJECTS)
		-\rm $(b64)
		-\rm $(SYNCLIB_OBJECTS)
		-\rm amttest
		-\rm libamt.so
