sProductData = 'PASTE_CONTENT_OF_PRODUCT.DAT_FILE';
sProductId = 'PASTE_PRODUCT_ID';
sAppVersion = 'PASTE_YOUR_APP_VERION';

%Loads the C library of LexActivator
sHeaderFile = './LexActivator.h';
sSharedLibrary = 'LexActivator';
%unloadlibrary(sSharedLibrary)
if ~libisloaded(sSharedLibrary)
    loadlibrary(sSharedLibrary,sHeaderFile)
end
%Creates and prints the list of the functions of the library with their arguments
%list = libfunctions(sSharedLibrary,'-full');

% Calls function to set the product data
status = calllib(sSharedLibrary,'SetProductData',[int8(sProductData) 0]);
if status ~= 0
    fprintf('Error Code: %.0f\n',status)
    return
end
% Calls function to set the product id
status = calllib(sSharedLibrary,'SetProductId',[int8(sProductId) 0], uint32(1));
if status ~= 0
    fprintf('Error Code: %.0f\n',status)
    return
end
% Calls function to set the app version
status = calllib(sSharedLibrary,'SetAppVersion',[int8(sAppVersion) 0]);
if status ~= 0
    fprintf('Error Code: %.0f\n',status)
    return
end

% Calls function to check if license is activated
status = calllib(sSharedLibrary,'IsLicenseGenuine');
if status == 0
    fprintf('License is genuinely activated!')
elseif 2 == status
    fprintf('License is genuinely activated but has expired!')
elseif 3 == status
    fprintf('License is genuinely activated but has been suspended!')
elseif 4 == status
    fprintf('License is genuinely activated but grace period is over!')
else
    % Calls function to check if license is activated
    trialStatus = calllib(sSharedLibrary,'IsTrialGenuine');
    if trialStatus == 0
        fprintf('Trial is valid')
    elseif 5 == trialStatus
        fprintf('Trial has expired!')
        % Time to buy the license and activate the app
        activate()
    else
        fprintf('Either trial has not started or has been tampered!')
        % Activating the trial
        activateTrial()
    end
end

function activate()
    sSharedLibrary = 'LexActivator';
    sLicenseKey = 'PASTE_LICENCE_KEY';
    % Calls function to set the license key
    status = calllib(sSharedLibrary,'SetLicenseKey',[int8(sLicenseKey) 0]);
	if status ~= 0
		fprintf('Error Code: %.0f\n',status)
		return
	end
    % Calls function to activate the license key
    status = calllib(sSharedLibrary,'ActivateLicense');
	if status == 0 || status == 2 || status == 3
		fprintf('License activated successfully: %.0f\n',status)
	else
		fprintf('License activation failed: %.0f\n',status)
	end
end

function activateTrial()
    sSharedLibrary = 'LexActivator';
    % Calls function to activate the trial
    status = calllib(sSharedLibrary,'ActivateTrial');
	if status == 0
		fprintf('Product trial activated successfully!')
	elseif status == 3
		fprintf('Product trial has expired!')
	else
		fprintf('Product trial activation failed:%.0f\n',status)
	end
end