
#include <iostream>
#include <iomanip>
#include <memory>


//#include <boost/asio/ip/address.hpp>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

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

struct result_item {
    string hostname;
    string ip;
    string version;
    int ping_enabled;
    string domainname;
    string buildNumber;
};

vector<result_item*> results;

void test_amt (string hostname, string user, string password, result_item& r);
void print_result ();

int main (int argc, char* argv[])
{

   if (argc != 5) {
       cout << "Wrong number of arguments" << endl;
       cout << "Usage: amttest startip endip user password " << endl;
       exit (1);
   }
   

   string user = string (argv[3]);
   string password = string (argv[4]);
   string sstartip = string (argv[1]);
   string sendip = string (argv[2]);

   in_addr saddr, eaddr; 
   
   if (!inet_aton (argv[1], &saddr)) {
       cerr << "Invalid start address " << argv[1] << endl;
       exit (1);
   }

   if (!inet_aton (argv[2], &eaddr)) {
       cerr << "Invalid end address " << argv[2] << endl;
       exit (1);
   }

   // auto startip = boost::asio::ip::address::from_string (sstartip);
   // auto endip = boost::asio::ip::address::from_string (sendip);

   cout << "Probing network from " << inet_ntoa (saddr) << " to " << inet_ntoa(eaddr) << endl;

   //if (eaddr.s_addr < saddr.s_addr) {
   //    cerr << "Starting ip must be smaller than the end ip" << endl;
   //    exit (1);
   //}

   // for incrementing we need host byorder (instead of network byte order)
   
   auto hstart = ntohl (saddr.s_addr);
   auto hend   = ntohl (eaddr.s_addr);

   if (hend < hstart) {
      cerr << "Starting ip must be smaller than the end ip" << endl;
      exit (1);
   }

    in_addr curaddr;

    for (auto hcurip = hstart; hcurip <= hend; hcurip++) {
        curaddr.s_addr = htonl (hcurip);
        cout << inet_ntoa (curaddr) << endl;

        auto he = gethostbyaddr (&curaddr, sizeof (curaddr), AF_INET);

        if (!he) continue;

        cout << "DNS Hostname: " << he->h_name << endl;

        result_item* tmp_result = new result_item;

        string shost (he->h_name);
        tmp_result->hostname = shost;

        test_amt (shost, user, password, *tmp_result);

        results.push_back (tmp_result);
    }

    print_result ();

   return 0;
}


namespace ws = Intel::WSManagement;
namespace wstyped = Intel::Manageability::Cim::Typed;

void test_amt (string hostname, string user, string password, result_item& r)
{
    cout << "testing " << hostname << "..." << endl;

    auto *owc = new ws::CimOpenWsmanClient (hostname,
					      16992,
					      false,
					      ws::DIGEST,
					      user,
					      password);

    try {

    wstyped::CIM_SoftwareIdentity si(owc);
    si.InstanceID ("AMT FW Core Version");
    si.Get ();
    //cout << "Core Version   : " << si.VersionString () << endl;
    r.version = si.VersionString ();
   
    si.InstanceID ("Build Number");
    si.Get ();
    //cout << "Build Number   : " << si.VersionString () << endl;
    r.buildNumber = si.VersionString ();

    wstyped::AMT_GeneralSettings gs(owc);
    gs.Get ();
    //cout << "AMT Hostname   : " << gs.HostName () << endl;
    //cout << "Domain Name    : " << gs.DomainName () << endl;
    //cout << "Ping Response  : " << gs.PingResponseEnabled () << endl;

    r.hostname = gs.HostName ();
    r.domainname = gs.DomainName ();
    
    r.ping_enabled = gs.PingResponseEnabled ();

    // Do we have to write the general settings
    bool change = false;

    if (!r.ping_enabled) {
        cout << "Enabling ping responce" << endl;
        gs.PingResponseEnabled (true);
        change = true;
    }

    const string domain = "th.physik.uni-frankfurt.de";

    /*if (r.domainname != domain) {
        cout << "Fixing Domainname" << endl;
        gs.DomainName (domain);
        change = true;
    }*/

    if (change) {
        cout << "Writing Changes" << endl;
        gs.Put ();
    }

    } catch (...) {
        cerr << "Error !!!" << endl;
        r.ping_enabled = 0;
    }

    delete owc;

}

void print_result () {

    cout << "----------------------------------------------------------------------------------"  << endl;
            cout << setw (15) << "Hostname"
             << setw (30) << "Domain"
             << setw (10)  << "Version"
             << setw (10)  << "BuildNo"
             << setw (5)  << "Ping" << endl;
    cout << "----------------------------------------------------------------------------------"  << endl;

    for (int i = 0; i < results.size (); ++i) {
        auto cur = results[i];

        cout << setw (15) << cur->hostname
             << setw (30) << cur->domainname
             << setw (10)  << cur->version
             << setw (10)  << cur->buildNumber
             << setw (5)  << cur->ping_enabled << endl;
    }
}
