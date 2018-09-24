sHeaderFile = './LexActivator.h';
sSharedLibrary = 'LexActivator';

function = init()

sProductData = 'PASTE_CONTENT_OF_PRODUCT.DAT_FILE';
sProductId = 'PASTE_PRODUCT_ID';
sAppVersion = 'PASTE_YOUR_APP_VERION';

%Loads the C library of LexActivator
loadlibrary(sSharedLibrary,sHeaderFile)
%Creates and prints the list of the functions of the library with their arguement
list = libfunctions(sSharedLibrary,'-full')
%calls function to set the product data
calllib(sSharedLibrary,'SetProductData',[int8(sProductData) 0])
%calls function to set the product id
calllib(sSharedLibrary,'SetProductId',[int8(sProductId) 0], uint32(1))
%calls function to set the product id
calllib(sSharedLibrary,'SetAppVersion',[int8(sAppVersion) 0])

end

function = activate()

sLicenseKey = 'PASTE_LICENCE_KEY';
%calls function to set the license key
calllib(sSharedLibrary,'SetLicenseKey',[int8(sLicenseKey) 0])
%calls function to activate the license key
calllib(sSharedLibrary,'ActivateLicense')

end


function = activateTrial() {

%calls function to activate the trial
calllib(sSharedLibrary,'ActivateTrial',[int8(sProductId) 0], uint32(1))

}

function = main() {
	init()
	var status C.int
	%calls function to check if license is activated
	calllib(sSharedLibrary,'IsLicenseGenuine')
	if C.LA_OK == status {
		fmt.Println("License is genuinely activated!")
	} else if C.LA_EXPIRED == status {
		fmt.Println("License is genuinely activated but has expired!")
	} else if C.LA_SUSPENDED == status {
		fmt.Println("License is genuinely activated but has been suspended!")
	} else if C.LA_GRACE_PERIOD_OVER == status {
		fmt.Println("License is genuinely activated but grace period is over!")
	} else {
		%calls function to check if license is activated
	    calllib(sSharedLibrary,'IsTrialGenuine')
		if C.LA_OK == trialStatus {
			fmt.Println("Trial is valid")
		} else if C.LA_TRIAL_EXPIRED == trialStatus {
			fmt.Println("Trial has expired!")
			// Time to buy the license and activate the app
			%calls function to check if license is activated
			activate()
		} else {
			fmt.Println("Either trial has not started or has been tampered!")
			// Activating the trial
			activateTrial()
		}
	}
}
