resource "volterra_virtual_k8s" "cluster" {
    name      = format("%s-vk8s", var.projectPrefix)
    vsite_refs {
      name      = "ves-io-all-res"
      namespace = "shared"
      tenant    = "ves-io"
    }
    namespace = var.namespace
    depends_on = [ volterra_namespace.ns ]
}

resource "volterra_api_credential" "cluster" {
  name      = format("%s-vk8s-kubeconfig", var.projectPrefix)
  api_credential_type = "KUBE_CONFIG"
  virtual_k8s_namespace = var.namespace
  virtual_k8s_name = volterra_virtual_k8s.cluster.name
  depends_on = [ volterra_namespace.ns ]
}

resource "local_file" "kubeconfig" {
  content  = base64decode(volterra_api_credential.cluster.data)
  filename = "/home/gitpod/.kube/config"
  depends_on = [ volterra_virtual_k8s.cluster ]
}

