sProductData = 'MjJEODM4OTQwNTUzMzYxNjM5NDk4MDI4OTZERDY0NkQ=.fcuUtjVJZ+zZ+E8SzqFoWjdk4RgojBmfxX7CVzWNJOVBSfGS8/XurBvnPsOEquFB80uNIAcqixhxnAlP9TGU1fmPFA1znSV5PAk/uZ3y2Bga636zqWcbCjcPZhJ2k50HBhsFdZO3+eqA/4AdPW+tNgaZ4FMZByy+n4HTkBC03yWQFdGLz9knFyier2Z9JJzE0ufSU/p5m8Mh2XZGa1rb3gOUmxGRa4GMJgHrVfGOEyGR/LKfObomxCwoML8NCUVWzjs308KuoxSYpj9UusrKC5stRxuOZZBtf7Oq0+khrdLu20mdP9UVR370RIF2phS/Y/XownlN+eIkMfzkoeCEGx7bQZSYw4HKvYYlmLQNymYDer4wG9Tqj2hkBhTzCxSBrWAzquc+CRlQp+Wc3dj2jIdMYEAO1RS+VC82FSZxGCcwyXtkBaiOEsuRfBPUl0A9DSIp6eNmol7NpXwkyUsavWmo04uday+WaDsntPSO3P3BMXG8aaCGELJibHyA2ZjWPpdG+3da5FrutGy9C4vWIx2gA2sjmjSYzP5wKNgzh41D4MroKBwGUZhO3Li6YbDJxkOqDaoryd7TKdsc36QkNe8z8QPRbXsO3Xv4yCOcb2d3dKiYfGwQyEG4m/1g8EEvDC3+AgUAerbJpH9EGEoQAqMpmIdm1pJkO97DMT7DQdlYqLiDVpjqDL0+VHPKy4EBPoeskcUeNae3FVOg1XDh7QKIvHXkVmu9gewRxHQiUQc0vgUrtC+EAdxb7s/peBoNonAOHaMUsWlmz5HLqlbHNOWtyD8HqTbTUVQoZtuvM3HVhVde2mQ2l4kiRM0Q1JTL';
sProductId = 'de5c962f-75b0-417d-a72a-5b474b8cb4bb';
sReleaseVersion = '1.0.0';

%Loads the C library of LexActivator
sHeaderFile = './LexActivator.h';
sStatusHeaderFile = './LexStatusCodes.h';
sSharedLibrary = 'LexActivator';

if not(libisloaded(sSharedLibrary))
   loadlibrary(sSharedLibrary,sHeaderFile, 'addheader',sStatusHeaderFile);
end

% Calls function to set the product data
status = calllib(sSharedLibrary,'SetProductData',toString(sProductData));

if status ~= 0
    fprintf('Error Code: %.0f\n',status)
    return
end

% Calls function to set the product id
status = calllib(sSharedLibrary,'SetProductId',toString(sProductId), uint32(1));
if status ~= 0
    fprintf('Error Code: %.0f\n',status)
    return
end

% Calls function to set the release version
status = calllib(sSharedLibrary,'SetReleaseVersion',toString(sReleaseVersion));
if status ~= 0
    fprintf('Error Code: %.0f\n',status)
    return
end

% Calls function to check if license is activated
status = calllib(sSharedLibrary,'IsLicenseGenuine');
if status == 0
    fprintf('License is genuinely activated!\n')
elseif status == 20
    fprintf('License is genuinely activated but has expired!\n')
    getLicenseAllowedDeactivations();  % <-- Explicit call added here
elseif status == 21
    fprintf('License is genuinely activated but has been suspended!\n')
elseif status == 22
    fprintf('License is genuinely activated but grace period is over!\n')
else
    % Calls function to check if trial is genuine
    trialStatus = calllib(sSharedLibrary,'IsTrialGenuine');
    if trialStatus == 0
        fprintf('Trial is valid\n')
    elseif trialStatus == 25
        fprintf('Trial has expired!\n')
        activate()
    else
        fprintf('Either trial has not started or has been tampered with!\n')
        activateTrial()
    end
end

function output = toString(input)
    if ispc
        output = [int8(input) 0];
    else
        output = input;
    end
end

function activate()
    sSharedLibrary = 'LexActivator';
    sLicenseKey = '064DA0-12BB7F-4EA489-F13C48-742ACE-FFFB2C';
    
    % Calls function to set the license key
    status = calllib(sSharedLibrary,'SetLicenseKey', toString(sLicenseKey));
	if status ~= 0
		fprintf('Error Code: %.0f\n',status)
		return
	end
    
    % Calls function to activate the license key
    status = calllib(sSharedLibrary,'ActivateLicense');
	if status == 0 || status == 20 || status == 21
		fprintf('License activated successfully: %.0f\n',status)
	else
		fprintf('License activation failed: %.0f\n',status)
	end
end

function getLicenseAllowedDeactivations()
    sSharedLibrary = 'LexActivator';
    
    % Calls function to get license allowed deactivations
    [status, allowedDeactivations] = calllib(sSharedLibrary, 'GetLicenseAllowedDeactivations', int32(0));
    
    if status == 0
        fprintf('Allowed Deactivations: %d\n', allowedDeactivations);
    else
        fprintf('Failed to get allowed deactivations, Status: %d\n', status);
    end
end

function activateTrial()
    sSharedLibrary = 'LexActivator';
    
    % Calls function to activate the trial
    status = calllib(sSharedLibrary,'ActivateTrial');
	if status == 0
		fprintf('Product trial activated successfully!\n')
	elseif status == 25
		fprintf('Product trial has expired!\n')
	else
		fprintf('Product trial activation failed: %.0f\n',status)
	end
end
