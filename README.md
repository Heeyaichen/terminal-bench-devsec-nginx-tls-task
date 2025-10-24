# Terminal-Bench DevSec Task: Nginx TLS Configuration and Iptables Fix

A production-ready engineering task designed for Terminal-Bench AI evaluation framework, focusing on DevOps/Security domain expertise.

**Task Overview:**
Diagnose and fix a misconfigured Nginx web server with broken TLS certificate paths and firewall configuration issues. The service is inaccessible due to an incorrect `iptables` firewall rule, and the HTTPS endpoint is serving an invalid TLS certificate due to a bad path in the Nginx configuration. The solver must use terminal tools like `iptables`, `curl`, `openssl`, `sed` and `grep` to correct both issues, making the service accessible and secure.

**Skills Tested:**
Solvers must demonstrate proficiency in:
- SSL/TLS certificate management and validation
- Nginx configuration debugging
- Command-line troubleshooting with `openssl`, `curl`, `sed`, and `grep`
- Container security limitations understanding

**Domain Chosen:**
DevOps / Security

**Docker Security Limitations**

1. iptables-restore will fail in unprivileged containers with errors like:

        Couldn't load match 'conntrack': No such file or directory

        Could not fetch rule set generation id: Permission denied


- Root cause: Docker restricts access to kernel modules and NET_ADMIN capability for security
This is expected behavior and reflects production container security practices

- Educational value: Understanding both the configuration and the limitations of containerized environments

The primary focus is on Nginx TLS configuration debugging, with iptables serving as context for network security concepts.

**Quickstart Run Notes:**
1.  Navigate to the `devsec_tls_iptables_fix` directory.
2.  Build the Docker image: `docker build -t task-image .`
3.  Run the container: `docker run --rm -it -p 8443:443 -p 8080:80 task-image bash`
4.  Inside the container, run the test suite to see the baseline failure: `./run-tests.sh`
5.  To validate the solution, run the oracle: `bash solution.sh`
6.  Rerun the tests to verify the fix: `./run-tests.sh`

**What Actually Gets Fixed**
- ✅ Nginx TLS Configuration - Certificate paths corrected, HTTPS service restored
- ⚠️ iptables Rules - Configuration validated but cannot be applied due to Docker constraints
-0 ✅ Service Accessibility - Web service becomes reachable on ports 80 and 443
- ✅ Certificate Validation - Proper TLS certificate served by Nginx

**Expected Behavior**

 - iptables-restore commands will show error messages - this is normal
- Tests will pass because Nginx configuration is the primary issue
- The solution demonstrates both successful fixes and infrastructure limitations

**Caveats:**
- No --privileged flag required: Task works in standard Docker security model
- iptables errors are documented: Part of the learning experience about container security
- Focus on practical troubleshooting: Real-world scenarios where not all tools have full privileges
- Production context: In actual deployments, firewall rules are managed at host/infrastructure level



**Educational Objectives**

- Nginx configuration debugging - Primary skill being tested
- TLS/SSL certificate management - Understanding certificate paths and validation
- Container security awareness - Learning about Docker privilege limitations
- Command-line troubleshooting - Using sed, openssl, curl, and other terminal tools
- Systems thinking - Understanding the relationship between different system components

**Checklist:**
- [x] Domain chosen from Allowed Task Domains
- [x] Self-contained `task.yaml` with all required sections
- [x] ≥ 6 deterministic tests covering criteria + edge cases; clear failure messages
- [x] `run-tests.sh` works and exits non-zero on any failure
- [x] Oracle passes 100%; baseline fails (~0%)
- [x] Core workload not Python (tests may be Python)
- [x] No network access; all inputs bundled; versions pinned; no privileged Docker flags
- [x] Reproducible build; runtime < 10 minutes; reasonable memory
- [x] Solution not copied/invoked in runtime/tests
- [x] README.md ≤ 1 page
- [x] Zip structure exactly as specified
- [x] Determinism check: repeated runs yield identical results

**📋 Compliance**

- ✅ Terminal-Bench specification compliant
- ✅ Offline execution (no network dependencies)
- ✅ Deterministic and reproducible
- ✅ Version-pinned dependencies
- ✅ Comprehensive test coverage
- ✅ Production-realistic scenario

**Troubleshooting Note:**
- The initial Dockerfile failed to build because the specific package versions listed were no longer available in the Ubuntu 22.04 repositories. To resolve this, I used `apt-cache madison` inside a temporary Ubuntu container to find the latest available package versions and updated the Dockerfile accordingly to maintain reproducibility.# devsecops
