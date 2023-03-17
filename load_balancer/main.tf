# Create backend
# Add instance group to backend
resource "google_compute_backend_service" "talos_backend" {
  name = "talos-backend"
  protocol = "TCP"
  timeout_sec = 300
  port_name = "tcpgroup"
  health_checks = ["${data.google_compute_health_check.talos_tcp_group_health_check.self_link}"]
  backend {
    group = "${data.google_compute_instance_group.talos_controlplane_group.id}"
  }
}


# Create tcp proxy
resource "google_compute_target_tcp_proxy" "talos_tcp_proxy" {
  name                = "talos-tcp-proxy"
  backend_service     = "${google_compute_backend_service.talos_backend.self_link}"
}


# Create LB IP
resource "google_compute_global_address" "talos_lb_ip" {
  name = "talos-lb-ip"
}

# Forward 443 from LB IP to tcp proxy
resource "google_compute_global_forwarding_rule" "talos_fwd_rule" {
  name                  = "talos-fwd-rule"
  target                = "${google_compute_target_tcp_proxy.talos_tcp_proxy.self_link}"
  port_range            = "443"
  ip_address            = "${google_compute_global_address.talos_lb_ip.address}"
}
