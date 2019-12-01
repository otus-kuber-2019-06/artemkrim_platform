local kube = import "https://github.com/bitnami-labs/kube-libsonnet/raw/52ba963ca44f7a4960aeae9ee0fbee44726e481f/kube.libsonnet";

local template_(name) = {
  svc: kube.Service(name) {
    target_pod:: $.deploy.spec.template,
  },

  deploy: kube.Deployment(name) {
    spec+: {
      template+: {
        spec+: {
          containers_: {
            template_: kube.Container("template_") {
              ports: [{containerPort: 80}],
              securityContext: {
                readOnlyRootFilesystem: true,
                runAsNonRoot: true,
                runAsUser: 10001,
                capabilities: {
                  drop:["all"],
                  add: ["NET_BIND_SERVICE"],
                },
              },
            },
          },
        },
      },
    },
  },
};


{
  catalogue: template_("catalogue") {
    deploy+: {
      spec+: {
        template+: {
          spec+: {
            containers_+: {
              template_+: {
                name: "catalogue",
                image: "weaveworksdemos/catalogue:0.3.5",
              },
            },
          },
        },
      },
    },
  },

  payment: template_("payment") {
    deploy+: {
      spec+: {
        template+: {
          spec+: {
            containers_+: {
              template_+: {
                name: "payment",
                image: "weaveworksdemos/payment:0.4.3",
              },
            },
          },
        },
      },
    },
  },
}