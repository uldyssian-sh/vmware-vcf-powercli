# Troubleshooting Guide

## Common Issues

### Connection Problems

#### Issue: Cannot connect to SDDC Manager
**Symptoms:** Connection timeout or authentication failure
**Solutions:**
- Verify SDDC Manager FQDN/IP
- Check network connectivity (ping, telnet 443)
- Validate credentials
- Check certificate trust settings

#### Issue: PowerCLI module not found
**Symptoms:** Module import errors
**Solutions:**
```powershell
# Check module installation
Get-Module -Name VCF.PowerCLI -ListAvailable

# Reinstall if needed
Install-Module -Name VCF.PowerCLI -Force
```

### Performance Issues

#### Issue: Slow cmdlet execution
**Solutions:**
- Use bulk operations where possible
- Implement parallel processing
- Optimize network connectivity
- Check SDDC Manager performance

### Certificate Issues

#### Issue: SSL certificate errors
**Solutions:**
```powershell
# Ignore certificate errors (development only)
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
```

## Logging and Debugging

### Enable Verbose Logging
```powershell
# Enable verbose output
$VerbosePreference = "Continue"

# Enable debug output
$DebugPreference = "Continue"
```# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
