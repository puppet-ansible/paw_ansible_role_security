# Puppet task for executing Ansible role: ansible_role_security
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_security"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_security"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_security\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_security"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_security"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_security_autoupdate_reboot) {
  $ExtraVars['security_autoupdate_reboot'] = $env:PT_security_autoupdate_reboot
}
if ($env:PT_security_autoupdate_reboot_time) {
  $ExtraVars['security_autoupdate_reboot_time'] = $env:PT_security_autoupdate_reboot_time
}
if ($env:PT_security_autoupdate_mail_to) {
  $ExtraVars['security_autoupdate_mail_to'] = $env:PT_security_autoupdate_mail_to
}
if ($env:PT_origin) {
  $ExtraVars['origin'] = $env:PT_origin
}
if ($env:PT_package) {
  $ExtraVars['package'] = $env:PT_package
}
if ($env:PT_security_ssh_port) {
  $ExtraVars['security_ssh_port'] = $env:PT_security_ssh_port
}
if ($env:PT_security_ssh_password_authentication) {
  $ExtraVars['security_ssh_password_authentication'] = $env:PT_security_ssh_password_authentication
}
if ($env:PT_security_ssh_permit_root_login) {
  $ExtraVars['security_ssh_permit_root_login'] = $env:PT_security_ssh_permit_root_login
}
if ($env:PT_security_ssh_usedns) {
  $ExtraVars['security_ssh_usedns'] = $env:PT_security_ssh_usedns
}
if ($env:PT_security_ssh_permit_empty_password) {
  $ExtraVars['security_ssh_permit_empty_password'] = $env:PT_security_ssh_permit_empty_password
}
if ($env:PT_security_ssh_challenge_response_auth) {
  $ExtraVars['security_ssh_challenge_response_auth'] = $env:PT_security_ssh_challenge_response_auth
}
if ($env:PT_security_ssh_gss_api_authentication) {
  $ExtraVars['security_ssh_gss_api_authentication'] = $env:PT_security_ssh_gss_api_authentication
}
if ($env:PT_security_ssh_x11_forwarding) {
  $ExtraVars['security_ssh_x11_forwarding'] = $env:PT_security_ssh_x11_forwarding
}
if ($env:PT_security_sshd_state) {
  $ExtraVars['security_sshd_state'] = $env:PT_security_sshd_state
}
if ($env:PT_security_ssh_restart_handler_state) {
  $ExtraVars['security_ssh_restart_handler_state'] = $env:PT_security_ssh_restart_handler_state
}
if ($env:PT_security_ssh_allowed_users) {
  $ExtraVars['security_ssh_allowed_users'] = $env:PT_security_ssh_allowed_users
}
if ($env:PT_security_ssh_allowed_groups) {
  $ExtraVars['security_ssh_allowed_groups'] = $env:PT_security_ssh_allowed_groups
}
if ($env:PT_security_sudoers_passwordless) {
  $ExtraVars['security_sudoers_passwordless'] = $env:PT_security_sudoers_passwordless
}
if ($env:PT_security_sudoers_passworded) {
  $ExtraVars['security_sudoers_passworded'] = $env:PT_security_sudoers_passworded
}
if ($env:PT_security_autoupdate_enabled) {
  $ExtraVars['security_autoupdate_enabled'] = $env:PT_security_autoupdate_enabled
}
if ($env:PT_security_autoupdate_blacklist) {
  $ExtraVars['security_autoupdate_blacklist'] = $env:PT_security_autoupdate_blacklist
}
if ($env:PT_security_autoupdate_additional_origins) {
  $ExtraVars['security_autoupdate_additional_origins'] = $env:PT_security_autoupdate_additional_origins
}
if ($env:PT_security_autoupdate_mail_on_error) {
  $ExtraVars['security_autoupdate_mail_on_error'] = $env:PT_security_autoupdate_mail_on_error
}
if ($env:PT_security_fail2ban_enabled) {
  $ExtraVars['security_fail2ban_enabled'] = $env:PT_security_fail2ban_enabled
}
if ($env:PT_security_fail2ban_custom_configuration_template) {
  $ExtraVars['security_fail2ban_custom_configuration_template'] = $env:PT_security_fail2ban_custom_configuration_template
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_security"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_security"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
