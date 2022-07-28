# Dynatrace OneAgent Autodeploy
# Garrett Haines (Sprint)


# YOUR host group
$hostGroup = "Autodeploy"

# YOUR tenant ID and URL
$tenantID = "dkz99748"
$tenantURL = "https://$($tenantID).sprint.dynatracelabs.com"

# YOUR token
$token = $args[0]



# Deploy Dynatrace's OneAgent
function deploy {
	# Download Dynatrace OneAgent installer for Windows
	echo "Downloading Dynatrace OneAgent installer for Windows..."
	Invoke-Expression -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '$($tenantURL)/api/v1/deployment/installer/agent/windows/default/latest?arch=x86&flavor=default' -Headers @{ 'Authorization' = 'Api-Token $($token)' } -OutFile 'Dynatrace-OneAgent-Installer-Windows.exe'"
	
	# Run file and begin installation
	echo "Installing OneAgent..."
	Invoke-Expression -Command ".\Dynatrace-OneAgent-Installer-Windows.exe --set-infra-only=false --set-app-log-content-access=true --set-host-group=$($hostGroup) --quiet"
	
	echo "Installation complete."
	echo "OneAgent has been successfully deployed on this device to the $($hostGroup) host group."
}


Add-Type -AssemblyName "PresentationFramework"
$alreadyInstalled = Get-WmiObject win32_product -filter "Name like 'Dynatrace OneAgent'"

if ($alreadyInstalled) {
	$caption = "OneAgent Already Installed"  
   	$message = "OneAgent is already installed on this device. Would you like to reinstall the program and overwrite your existing local data?"
	
	$continue = "No"
	$continue = [System.Windows.MessageBox]::Show($message, $caption, 'YesNo');
	 
	if ($continue -eq 'Yes') {
		deploy
	}
	else {
		echo "Installation aborted."
	}
} 
else {
	deploy
}
