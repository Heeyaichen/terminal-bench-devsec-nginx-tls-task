import pytest
import subprocess
import requests

def check_port_status(port):
    """Checks if a port is open using netcat."""
    try:
        # Use nc to check if the port is listening
        subprocess.run(
            ['nc', '-z', '-w', '5', 'localhost', str(port)],
            check=True,
            capture_output=True,
            text=True
        )
        return True
    except subprocess.CalledProcessError:
        return False
    
def test_iptables_rules_correct():
    """Test that iptables rules file contains correct configuration."""
    with open('/etc/iptables/rules.v4', 'r') as f:
        content = f.read()
    assert '-A INPUT -p tcp --dport 80 -j ACCEPT' in content
    assert '-A INPUT -p tcp --dport 443 -j ACCEPT' in content

def test_port_80_is_open():
    """Test if port 80 is open to incoming connections."""
    assert check_port_status(80), "Port 80 (HTTP) is not open. Check the iptables configuration."

def test_port_443_is_open():
    """Test if port 443 is open to incoming connections."""
    assert check_port_status(443), "Port 443 (HTTPS) is not open. Check the iptables configuration."

def test_https_request_succeeds():
    """Test if a curl request to the HTTPS endpoint succeeds."""
    try:
        # We need to disable SSL verification because the certificate is self-signed for this task
        response = requests.get('https://localhost:443', verify=False, timeout=10)
        assert response.status_code == 200, f"Expected status 200, got {response.status_code}. The HTTPS service may be down or misconfigured."
    except requests.exceptions.RequestException as e:
        pytest.fail(f"Failed to connect to HTTPS endpoint on port 443: {e}")

def test_https_certificate_is_valid():
    """Test if the correct certificate is being served."""
    try:
        # Use openssl to check the certificate details. This will fail if the cert path is wrong.
        cmd = "openssl s_client -connect localhost:443 -servername localhost -showcerts </dev/null 2>/dev/null | openssl x509 -noout -subject"
        output = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        assert "CN" in output.stdout and "localhost" in output.stdout, "The server is not serving the correct certificate. Check the Nginx TLS configuration paths."
    except subprocess.CalledProcessError:
        pytest.fail("Failed to get certificate details. The Nginx configuration might be pointing to a non-existent certificate.")
    
def test_nginx_is_running():
    """Test if the nginx service is running."""
    try:
        subprocess.run(
            ["pgrep", "nginx"],
            check=True,
            capture_output=True
        )
    except subprocess.CalledProcessError:
        pytest.fail("Nginx is not running. Check its configuration and status.")
        
def test_baseline_fails():
    """Ensure the baseline (unmodified state) does not pass accidentally."""
    assert not test_port_80_is_open(), "Baseline unexpectedly passes: Port 80 is already open."
    assert not test_port_443_is_open(), "Baseline unexpectedly passes: Port 443 is already open."