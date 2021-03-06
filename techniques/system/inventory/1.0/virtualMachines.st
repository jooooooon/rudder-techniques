#####################################################################################
# Copyright 2011 Normation SAS
#####################################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, Version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#####################################################################################

# Definition of variables and classes usefull for all the VM part
# Detect the existence of installed VM containenr on the computer

bundle common virtualMachines
{
  vars:
    # Files names for the installed VM lists
      "VBoxListFile" string => "${g.rudder_var_tmp}/VBoxList.list";
      "VMWareListFile" string => "${g.rudder_var_tmp}/VMWareList.list";
      "VMWareScript_ServerLocation" string => "${g.rudder_dependencies}/vmware_info.sh";

    # Attribut name for the VM tag in the inventory file
      "VBoxAttr" string => "VBox";
      "VMWareAttr" string => "VMWare";

    # Tools for fetching data
      "VMWareScript" string => "${g.inventory_directory}/vmware_info.sh";

&if(NOVA)&
    windows.!cygwin::
      "virtual_box_install_path" string => execresult("${sys.winsysdir}\cmd.exe /c \"echo %VBOX_INSTALL_PATH%\"", "noshell"),
        comment => "Looking for VirtualBox environment variables";
&endif&


    cygwin::
      "virtual_box_install_path" string => execresult("/usr/bin/echo $VBOX_INSTALL_PATH | /usr/bin/sed ''s/\\\/\//g'' ", "useshell"),
        comment => "Looking for VirtualBox environment variables";


  classes:
    linux::
      "VirtualBoxInstalled" expression => fileexists("/usr/bin/VBoxManage"),
        comment => "Checking installation of VirtualBox";

      "VMWareInstalled" expression => fileexists("/usr/bin/wmrun"),
        comment => "Checking installation of VMWare";

&if(NOVA)&
    windows::
      "VirtualBoxInstalled" not => regcmp("", "${virtual_box_install_path}");
&endif&
}

