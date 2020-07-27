# PORTS INVESTIGATION
 
## What's this?
This is a PowerShell script that provides information about local ports in Windows and the applications using them.

## What problem does it solve?
In any Windows computer there are already several native tools that can help you grab the same information like netstat & task manager. But the cosolidation of all information takes several steps that you have to repeat for each port.
This script with a single step allows you to get meaningul information about one or many open ports in Windows. This is specially useful for Windows Server administrators when investigating if a particular application is running on a server and which port(s) it is listening to.

Information provided:
- Port
- Process description
- Process id
- Ip address
- Process installation Path.

## How to use it
Just run the PowerShell script like any other script from PowerShell cli or from PowerShell ISE. Provide a comma separated list of ports, i.e. -Port '80,443' to scan specific port(s) or leavy empty to scan ports commonly used by Web applications (80,443,8080,8443,8009,7001,7002,8001,5556).


Example:
  
    .\ports.ps1 -port "80,443"
  
  
