
#include <iostream>
#include <memory>

#include <xercesc/util/PlatformUtils.hpp>

//#include <OpenWsmanClient.h>

#include <AMT_GeneralSettings.h>
#include <CIM_SoftwareIdentity.h>
#include <AMT_MessageLog.h>
#include <CIM_PowerManagementService.h>
#include <CIM_AssociatedPowerManagementService.h>
#include <CIM_ComputerSystem.h>
#include <CimOpenWsmanClient.h>


using namespace std;
using namespace WsmanClientNamespace;

using namespace Intel::Manageability::Exceptions;
using namespace Intel::Manageability::Cim::Typed;
using namespace Intel::WSManagement;


XERCES_CPP_NAMESPACE_USE

//******************************************************************

#pragma pack(1)
typedef struct _EventLogRecord
{
	unsigned int TimeStamp;
	unsigned char DeviceAddress;
	unsigned char EventSensorType;
	unsigned char EventType;
	unsigned char EventOffset;
	unsigned char EventSourceType;
	unsigned char EventSeverity;
	unsigned char SensorNumber;
	unsigned char Entity;
	unsigned char EntityInstance;
	unsigned char EventData[8];
}EventLogRecord;
#pragma pack ()

//void PrintRecord(const AMT_MessageLog::GetRecord_OUTPUT &out)
void PrintRecord(string recordstring, int Index)
{
    cout << "Record Number: " << Index << endl;
    
    // Convert vector<unsigned char> to string;
    //auto tmpbuf = out.RecordData();
    //string s = string(tmpbuf.begin(), tmpbuf.end());
    Base64 record(recordstring);
	
    EventLogRecord *e = (EventLogRecord*)record.Data ();

    printf("TimeStamp        %u\n",(unsigned int) e->TimeStamp);
    printf("DeviceAddress    %u\n",(unsigned int) e->DeviceAddress);
    printf("Entity           %u\n",(unsigned int)e->Entity);
    printf("EventSensorType  %u\n",(unsigned int)e->EventSensorType);
    printf("EventSourceType  %u\n",(unsigned int)e->EventSourceType);
    printf("EventSeverity    %u\n",(unsigned int)e->EventSeverity);
    printf("SensorNumber     %u\n",(unsigned int)e->SensorNumber);
    printf("EventType        %u\n",(unsigned int) e->EventType);
    printf("EventData       ");
    for(unsigned int j = 0; j < 8; j++)
    {
	printf(" %02x", e->EventData[j]);
    }
    printf("\n");    
}
//*******************************************************************

int main (int argc, char* argv[])
{
   //CimXMLUtilsNamespace::InitXMLLibrary ();
   
   if (argc != 4) {
       cout << "Wrong number of arguments" << endl;
       cout << "Usage: amttest host user password" << endl;
   }
   
   string host = string (argv[1]);
   string user = string (argv[2]);
   string password = string (argv[3]);

   CimOpenWsmanClient *owc = new CimOpenWsmanClient (host,
					      16992,
					      false,
					      DIGEST,
					      user,
					      password);

   
    

   //std::cout << owc->Identify ();

   //initXMLLibrary ();

   //CimClass::RegisterDefaultWsmanProvider (owc);


    CIM_SoftwareIdentity si(owc);
    si.InstanceID ("AMT FW Core Version");
    si.Get ();
    cout << "Core Version   : " << si.VersionString () << endl;


    AMT_GeneralSettings gs(owc);
    gs.Get ();
    cout << "AMT Hostname   : " << gs.HostName () << endl;
    cout << "Domain Name    : " << gs.DomainName () << endl;
    cout << "Ping Response  : " << gs.PingResponseEnabled () << endl;
    
       
    
    //vector<shared_ptr<CIM_SoftwareIdentity> > 
    auto siVector = si.Enumerate (owc);
        
    for(unsigned int i = 0; i < siVector.size(); i++) {
         CIM_SoftwareIdentity *tmp = (CIM_SoftwareIdentity*)siVector[i].get();
         cout << siVector[i]->VersionString () << endl;
//       cout << i << " " << tmp.InstanceID () << ": " << tmp->VersionString () << endl;
//       cout << i << " " << siVector[i]->InstanceID << ": " << siVector[i].VersionString.c_str() << endl;
//       if(0 == siVector[i].InstanceID.compare("AMT FW Core Version")) {
//	    cout << "AMT FW Core Version: " << siVector[i].VersionString.c_str() << endl << endl;                         
//            break;
//      }
    }


/*    CimClassContainer<CIM_ManagedElement> maCont;
    cout << "Enumerate (polymorphic) CIM_ManagedElement" << endl;
    
    CIM_ManagedElement::Enumerate(maCont);
    cout << "Enumerate CIM_ManagedElement response:" << endl;
     
     for(int i = 0; i < maCont.Size(); i++) {
	cout << "(" << i << ")" << endl << maCont[i]->Serialize().c_str() << endl;
     }
     cout << endl;
*/

   //AMT_GeneralSettings gs;
    //gs.Get ();
   
   //NameValuePairs nvp;
   
    AMT_MessageLog log (owc);
    //log.Name ("Intel(r) AMT:messageLog 1");
    log.Get ();

    cout << log.Name() << endl;
    cout << ((log.IsFrozen ()) ? "Log frozen" : "Log is not frozen") << endl;
    cout << "Max number of records    : " << log.MaxNumberOfRecords() << endl;
    cout << "Current number of records: " << log.CurrentNumberOfRecords() << endl;
    cout << endl;

    //// first position the pointer to the first record
    //AMT_MessageLog::PositionToFirstRecord_INPUT inputPositionToFirstRecord;
    //AMT_MessageLog::PositionToFirstRecord_OUTPUT outputPositionToFirstRecord;

    //AMT_MessageLog::GetRecords_INPUT inputGetRecords;
    //AMT_MessageLog::GetRecords_OUTPUT outputGetRecords;

    //bool moreRecords;
    //unsigned int cnt = 0;
    //string identifier;
	
    //log.InvokePositionToFirstRecord(inputPositionToFirstRecord, outputPositionToFirstRecord);
    
    //identifier = outputPositionToFirstRecord.IterationIdentifier;
    //inputGetRecords.IterationIdentifier = identifier;
  
    AMT_MessageLog::PositionToFirstRecord_OUTPUT outputPositionToFirstRecord;

    bool moreRecords;
    int cnt = 0;
    string identifier;

    int status = log.PositionToFirstRecord(outputPositionToFirstRecord);
    
    AMT_MessageLog::GetRecords_INPUT inputGetRecords;
    AMT_MessageLog::GetRecords_OUTPUT outputGetRecords;

    identifier = outputPositionToFirstRecord.IterationIdentifier();
    inputGetRecords.IterationIdentifier(identifier);
    cout << "Identifier: " << identifier << endl;
    
    do {
	inputGetRecords.MaxReadRecords (100);
	log.GetRecords(inputGetRecords, outputGetRecords);
	
	for (int i = 0; i < outputGetRecords.RecordArray().size(); i++) {
	    PrintRecord (outputGetRecords.RecordArray().at(i), i);
	}
	
	moreRecords = !outputGetRecords.NoMoreRecords();
	inputGetRecords.IterationIdentifier (outputGetRecords.IterationIdentifier()); // Does this change?
    } while (moreRecords);


    CIM_AssociatedPowerManagementService powerState (owc);
    powerState.Get ();
    switch (powerState.PowerState ()) {
	case 2:
	    cout << "Power is on" << endl;
	    break;
	case 6:
	    cout << "Power is off (soft)" << endl;
	    break;
	case 8:
	    cout << "Power is off (hard)" << endl;
	    break;
	default:
	    cout << "Other Power State" << endl;
	    break;
    }
	
	
	
    // Power Managment 
    CIM_PowerManagementService power (owc);
    power.Get ();
    
    CIM_PowerManagementService::RequestPowerStateChange_INPUT pwrin;
    CIM_PowerManagementService::RequestPowerStateChange_OUTPUT pwrout;
	
    CIM_ComputerSystem computerSystem(owc);
    computerSystem.Name("ManagedSystem");
    computerSystem.Get();
    
    pwrin.PowerState (8);
    pwrin.ManagedElement (computerSystem.Reference ());
    
    // power.RequestPowerStateChange (pwrin, pwrout);

    //cout << computerSystem.Serialize () << endl;

    delete owc;
			
    //CimXMLUtilsNamespace::TerminateXMLLibrary();			
    
    return 0;
}




