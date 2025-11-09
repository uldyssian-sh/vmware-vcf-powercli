# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do not** create a public GitHub issue
2. Send details to the repository maintainers
3. Include steps to reproduce
4. Provide impact assessment

## Security Standards

### Credential Management
- Never store credentials in code
- Use Windows Credential Manager or secure vaults
- Implement credential rotation

### Network Security
- Use TLS/SSL for all connections
- Validate certificates when possible
- Implement connection timeouts

### Input Validation
- Sanitize all user inputs
- Validate parameter types and ranges
- Prevent injection attacks

### Logging
- Log security events
- Avoid logging sensitive data
- Implement log rotation

## Security Tools

This repository uses:
- PSScriptAnalyzer for code analysis
- Bandit for security scanning
- SonarCloud for vulnerability detection# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
