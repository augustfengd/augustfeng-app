package traefik

crd: manifests: [{
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "ingressroutes.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "IngressRoute"
			listKind: "IngressRouteList"
			plural:   "ingressroutes"
			singular: "ingressroute"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "IngressRoute is the CRD implementation of a Traefik HTTP Router."
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "IngressRouteSpec defines the desired state of IngressRoute."
						properties: {
							entryPoints: {
								description: """
	EntryPoints defines the list of entry point names to bind to.
	Entry points have to be configured in the static configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/entrypoints/
	Default: all.
	"""
								items: type: "string"
								type: "array"
							}
							routes: {
								description: "Routes defines the list of routes."
								items: {
									description: "Route holds the HTTP route configuration."
									properties: {
										kind: {
											description: """
	Kind defines the kind of the route.
	Rule is the only supported kind.
	"""
											enum: ["Rule"]
											type: "string"
										}
										match: {
											description: """
	Match defines the router's rule.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#rule
	"""
											type: "string"
										}
										middlewares: {
											description: """
	Middlewares defines the list of references to Middleware resources.
	More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#kind-middleware
	"""
											items: {
												description: "MiddlewareRef is a reference to a Middleware resource."
												properties: {
													name: {
														description: "Name defines the name of the referenced Middleware resource."
														type:        "string"
													}
													namespace: {
														description: "Namespace defines the namespace of the referenced Middleware resource."
														type:        "string"
													}
												}
												required: ["name"]
												type: "object"
											}
											type: "array"
										}
										priority: {
											description: """
	Priority defines the router's priority.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#priority
	"""
											type: "integer"
										}
										services: {
											description: """
	Services defines the list of Service.
	It can contain any combination of TraefikService and/or reference to a Kubernetes Service.
	"""
											items: {
												description: "Service defines an upstream HTTP service to proxy traffic to."
												properties: {
													healthCheck: {
														description: "Healthcheck defines health checks for ExternalName services."
														properties: {
															followRedirects: {
																description: """
	FollowRedirects defines whether redirects should be followed during the health check calls.
	Default: true
	"""
																type: "boolean"
															}
															headers: {
																additionalProperties: type: "string"
																description: "Headers defines custom headers to be sent to the health check endpoint."
																type:        "object"
															}
															hostname: {
																description: "Hostname defines the value of hostname in the Host header of the health check request."
																type:        "string"
															}
															interval: {
																anyOf: [{
																	type: "integer"
																}, {
																	type: "string"
																}]
																description: """
	Interval defines the frequency of the health check calls.
	Default: 30s
	"""
																"x-kubernetes-int-or-string": true
															}
															method: {
																description: "Method defines the healthcheck method."
																type:        "string"
															}
															mode: {
																description: """
	Mode defines the health check mode.
	If defined to grpc, will use the gRPC health check protocol to probe the server.
	Default: http
	"""
																type: "string"
															}
															path: {
																description: "Path defines the server URL path for the health check endpoint."
																type:        "string"
															}
															port: {
																description: "Port defines the server URL port for the health check endpoint."
																type:        "integer"
															}
															scheme: {
																description: "Scheme replaces the server URL scheme for the health check endpoint."
																type:        "string"
															}
															status: {
																description: "Status defines the expected HTTP status code of the response to the health check request."
																type:        "integer"
															}
															timeout: {
																anyOf: [{
																	type: "integer"
																}, {
																	type: "string"
																}]
																description: """
	Timeout defines the maximum duration Traefik will wait for a health check request before considering the server unhealthy.
	Default: 5s
	"""
																"x-kubernetes-int-or-string": true
															}
														}
														type: "object"
													}
													kind: {
														description: "Kind defines the kind of the Service."
														enum: [
															"Service",
															"TraefikService",
														]
														type: "string"
													}
													name: {
														description: """
	Name defines the name of the referenced Kubernetes Service or TraefikService.
	The differentiation between the two is specified in the Kind field.
	"""
														type: "string"
													}
													namespace: {
														description: "Namespace defines the namespace of the referenced Kubernetes Service or TraefikService."
														type:        "string"
													}
													nativeLB: {
														description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
														type: "boolean"
													}
													nodePortLB: {
														description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
														type: "boolean"
													}
													passHostHeader: {
														description: """
	PassHostHeader defines whether the client Host header is forwarded to the upstream Kubernetes Service.
	By default, passHostHeader is true.
	"""
														type: "boolean"
													}
													port: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
														"x-kubernetes-int-or-string": true
													}
													responseForwarding: {
														description: "ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client."
														properties: flushInterval: {
															description: """
	FlushInterval defines the interval, in milliseconds, in between flushes to the client while copying the response body.
	A negative value means to flush immediately after each write to the client.
	This configuration is ignored when ReverseProxy recognizes a response as a streaming response;
	for such responses, writes are flushed to the client immediately.
	Default: 100ms
	"""
															type: "string"
														}
														type: "object"
													}
													scheme: {
														description: """
	Scheme defines the scheme to use for the request to the upstream Kubernetes Service.
	It defaults to https when Kubernetes Service port is 443, http otherwise.
	"""
														type: "string"
													}
													serversTransport: {
														description: """
	ServersTransport defines the name of ServersTransport resource to use.
	It allows to configure the transport between Traefik and your servers.
	Can only be used on a Kubernetes Service.
	"""
														type: "string"
													}
													sticky: {
														description: """
	Sticky defines the sticky sessions configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/services/#sticky-sessions
	"""
														properties: cookie: {
															description: "Cookie defines the sticky cookie configuration."
															properties: {
																httpOnly: {
																	description: "HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript."
																	type:        "boolean"
																}
																maxAge: {
																	description: """
	MaxAge indicates the number of seconds until the cookie expires.
	When set to a negative number, the cookie expires immediately.
	When set to zero, the cookie never expires.
	"""
																	type: "integer"
																}
																name: {
																	description: "Name defines the Cookie name."
																	type:        "string"
																}
																sameSite: {
																	description: """
	SameSite defines the same site policy.
	More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
	"""
																	type: "string"
																}
																secure: {
																	description: "Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS)."
																	type:        "boolean"
																}
															}
															type: "object"
														}
														type: "object"
													}
													strategy: {
														description: """
	Strategy defines the load balancing strategy between the servers.
	RoundRobin is the only supported value at the moment.
	"""
														type: "string"
													}
													weight: {
														description: """
	Weight defines the weight and should only be specified when Name references a TraefikService object
	(and to be precise, one that embeds a Weighted Round Robin).
	"""
														type: "integer"
													}
												}
												required: ["name"]
												type: "object"
											}
											type: "array"
										}
										syntax: {
											description: """
	Syntax defines the router's rule syntax.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#rulesyntax
	"""
											type: "string"
										}
									}
									required: [
										"kind",
										"match",
									]
									type: "object"
								}
								type: "array"
							}
							tls: {
								description: """
	TLS defines the TLS configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#tls
	"""
								properties: {
									certResolver: {
										description: """
	CertResolver defines the name of the certificate resolver to use.
	Cert resolvers have to be configured in the static configuration.
	More info: https://doc.traefik.io/traefik/v3.1/https/acme/#certificate-resolvers
	"""
										type: "string"
									}
									domains: {
										description: """
	Domains defines the list of domains that will be used to issue certificates.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#domains
	"""
										items: {
											description: "Domain holds a domain name with SANs."
											properties: {
												main: {
													description: "Main defines the main domain name."
													type:        "string"
												}
												sans: {
													description: "SANs defines the subject alternative domain names."
													items: type: "string"
													type: "array"
												}
											}
											type: "object"
										}
										type: "array"
									}
									options: {
										description: """
	Options defines the reference to a TLSOption, that specifies the parameters of the TLS connection.
	If not defined, the `default` TLSOption is used.
	More info: https://doc.traefik.io/traefik/v3.1/https/tls/#tls-options
	"""
										properties: {
											name: {
												description: """
	Name defines the name of the referenced TLSOption.
	More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#kind-tlsoption
	"""
												type: "string"
											}
											namespace: {
												description: """
	Namespace defines the namespace of the referenced TLSOption.
	More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#kind-tlsoption
	"""
												type: "string"
											}
										}
										required: ["name"]
										type: "object"
									}
									secretName: {
										description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
										type:        "string"
									}
									store: {
										description: """
	Store defines the reference to the TLSStore, that will be used to store certificates.
	Please note that only `default` TLSStore can be used.
	"""
										properties: {
											name: {
												description: """
	Name defines the name of the referenced TLSStore.
	More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#kind-tlsstore
	"""
												type: "string"
											}
											namespace: {
												description: """
	Namespace defines the namespace of the referenced TLSStore.
	More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#kind-tlsstore
	"""
												type: "string"
											}
										}
										required: ["name"]
										type: "object"
									}
								}
								type: "object"
							}
						}
						required: ["routes"]
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "ingressroutetcps.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "IngressRouteTCP"
			listKind: "IngressRouteTCPList"
			plural:   "ingressroutetcps"
			singular: "ingressroutetcp"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "IngressRouteTCP is the CRD implementation of a Traefik TCP Router."
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "IngressRouteTCPSpec defines the desired state of IngressRouteTCP."
						properties: {
							entryPoints: {
								description: """
	EntryPoints defines the list of entry point names to bind to.
	Entry points have to be configured in the static configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/entrypoints/
	Default: all.
	"""
								items: type: "string"
								type: "array"
							}
							routes: {
								description: "Routes defines the list of routes."
								items: {
									description: "RouteTCP holds the TCP route configuration."
									properties: {
										match: {
											description: """
	Match defines the router's rule.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#rule_1
	"""
											type: "string"
										}
										middlewares: {
											description: "Middlewares defines the list of references to MiddlewareTCP resources."
											items: {
												description: "ObjectReference is a generic reference to a Traefik resource."
												properties: {
													name: {
														description: "Name defines the name of the referenced Traefik resource."
														type:        "string"
													}
													namespace: {
														description: "Namespace defines the namespace of the referenced Traefik resource."
														type:        "string"
													}
												}
												required: ["name"]
												type: "object"
											}
											type: "array"
										}
										priority: {
											description: """
	Priority defines the router's priority.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#priority_1
	"""
											type: "integer"
										}
										services: {
											description: "Services defines the list of TCP services."
											items: {
												description: "ServiceTCP defines an upstream TCP service to proxy traffic to."
												properties: {
													name: {
														description: "Name defines the name of the referenced Kubernetes Service."
														type:        "string"
													}
													namespace: {
														description: "Namespace defines the namespace of the referenced Kubernetes Service."
														type:        "string"
													}
													nativeLB: {
														description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
														type: "boolean"
													}
													nodePortLB: {
														description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
														type: "boolean"
													}
													port: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
														"x-kubernetes-int-or-string": true
													}
													proxyProtocol: {
														description: """
	ProxyProtocol defines the PROXY protocol configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/services/#proxy-protocol
	"""
														properties: version: {
															description: "Version defines the PROXY Protocol version to use."
															type:        "integer"
														}
														type: "object"
													}
													serversTransport: {
														description: """
	ServersTransport defines the name of ServersTransportTCP resource to use.
	It allows to configure the transport between Traefik and your servers.
	Can only be used on a Kubernetes Service.
	"""
														type: "string"
													}
													terminationDelay: {
														description: """
	TerminationDelay defines the deadline that the proxy sets, after one of its connected peers indicates
	it has closed the writing capability of its connection, to close the reading capability as well,
	hence fully terminating the connection.
	It is a duration in milliseconds, defaulting to 100.
	A negative value means an infinite deadline (i.e. the reading capability is never closed).
	Deprecated: TerminationDelay is not supported APIVersion traefik.io/v1, please use ServersTransport to configure the TerminationDelay instead.
	"""
														type: "integer"
													}
													tls: {
														description: "TLS determines whether to use TLS when dialing with the backend."
														type:        "boolean"
													}
													weight: {
														description: "Weight defines the weight used when balancing requests between multiple Kubernetes Service."
														type:        "integer"
													}
												}
												required: [
													"name",
													"port",
												]
												type: "object"
											}
											type: "array"
										}
										syntax: {
											description: """
	Syntax defines the router's rule syntax.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#rulesyntax_1
	"""
											type: "string"
										}
									}
									required: ["match"]
									type: "object"
								}
								type: "array"
							}
							tls: {
								description: """
	TLS defines the TLS configuration on a layer 4 / TCP Route.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#tls_1
	"""
								properties: {
									certResolver: {
										description: """
	CertResolver defines the name of the certificate resolver to use.
	Cert resolvers have to be configured in the static configuration.
	More info: https://doc.traefik.io/traefik/v3.1/https/acme/#certificate-resolvers
	"""
										type: "string"
									}
									domains: {
										description: """
	Domains defines the list of domains that will be used to issue certificates.
	More info: https://doc.traefik.io/traefik/v3.1/routing/routers/#domains
	"""
										items: {
											description: "Domain holds a domain name with SANs."
											properties: {
												main: {
													description: "Main defines the main domain name."
													type:        "string"
												}
												sans: {
													description: "SANs defines the subject alternative domain names."
													items: type: "string"
													type: "array"
												}
											}
											type: "object"
										}
										type: "array"
									}
									options: {
										description: """
	Options defines the reference to a TLSOption, that specifies the parameters of the TLS connection.
	If not defined, the `default` TLSOption is used.
	More info: https://doc.traefik.io/traefik/v3.1/https/tls/#tls-options
	"""
										properties: {
											name: {
												description: "Name defines the name of the referenced Traefik resource."
												type:        "string"
											}
											namespace: {
												description: "Namespace defines the namespace of the referenced Traefik resource."
												type:        "string"
											}
										}
										required: ["name"]
										type: "object"
									}
									passthrough: {
										description: "Passthrough defines whether a TLS router will terminate the TLS connection."
										type:        "boolean"
									}
									secretName: {
										description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
										type:        "string"
									}
									store: {
										description: """
	Store defines the reference to the TLSStore, that will be used to store certificates.
	Please note that only `default` TLSStore can be used.
	"""
										properties: {
											name: {
												description: "Name defines the name of the referenced Traefik resource."
												type:        "string"
											}
											namespace: {
												description: "Namespace defines the namespace of the referenced Traefik resource."
												type:        "string"
											}
										}
										required: ["name"]
										type: "object"
									}
								}
								type: "object"
							}
						}
						required: ["routes"]
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "ingressrouteudps.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "IngressRouteUDP"
			listKind: "IngressRouteUDPList"
			plural:   "ingressrouteudps"
			singular: "ingressrouteudp"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: "IngressRouteUDP is a CRD implementation of a Traefik UDP Router."
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "IngressRouteUDPSpec defines the desired state of a IngressRouteUDP."
						properties: {
							entryPoints: {
								description: """
	EntryPoints defines the list of entry point names to bind to.
	Entry points have to be configured in the static configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/entrypoints/
	Default: all.
	"""
								items: type: "string"
								type: "array"
							}
							routes: {
								description: "Routes defines the list of routes."
								items: {
									description: "RouteUDP holds the UDP route configuration."
									properties: services: {
										description: "Services defines the list of UDP services."
										items: {
											description: "ServiceUDP defines an upstream UDP service to proxy traffic to."
											properties: {
												name: {
													description: "Name defines the name of the referenced Kubernetes Service."
													type:        "string"
												}
												namespace: {
													description: "Namespace defines the namespace of the referenced Kubernetes Service."
													type:        "string"
												}
												nativeLB: {
													description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
													type: "boolean"
												}
												nodePortLB: {
													description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
													type: "boolean"
												}
												port: {
													anyOf: [{
														type: "integer"
													}, {
														type: "string"
													}]
													description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
													"x-kubernetes-int-or-string": true
												}
												weight: {
													description: "Weight defines the weight used when balancing requests between multiple Kubernetes Service."
													type:        "integer"
												}
											}
											required: [
												"name",
												"port",
											]
											type: "object"
										}
										type: "array"
									}
									type: "object"
								}
								type: "array"
							}
						}
						required: ["routes"]
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "middlewares.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "Middleware"
			listKind: "MiddlewareList"
			plural:   "middlewares"
			singular: "middleware"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					Middleware is the CRD implementation of a Traefik Middleware.
					More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/overview/
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "MiddlewareSpec defines the desired state of a Middleware."
						properties: {
							addPrefix: {
								description: """
	AddPrefix holds the add prefix middleware configuration.
	This middleware updates the path of a request before forwarding it.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/addprefix/
	"""
								properties: prefix: {
									description: """
	Prefix is the string to add before the current path in the requested URL.
	It should include a leading slash (/).
	"""
									type: "string"
								}
								type: "object"
							}
							basicAuth: {
								description: """
	BasicAuth holds the basic auth middleware configuration.
	This middleware restricts access to your services to known users.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/basicauth/
	"""
								properties: {
									headerField: {
										description: """
	HeaderField defines a header field to store the authenticated user.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/basicauth/#headerfield
	"""
										type: "string"
									}
									realm: {
										description: """
	Realm allows the protected resources on a server to be partitioned into a set of protection spaces, each with its own authentication scheme.
	Default: traefik.
	"""
										type: "string"
									}
									removeHeader: {
										description: """
	RemoveHeader sets the removeHeader option to true to remove the authorization header before forwarding the request to your service.
	Default: false.
	"""
										type: "boolean"
									}
									secret: {
										description: "Secret is the name of the referenced Kubernetes Secret containing user credentials."
										type:        "string"
									}
								}
								type: "object"
							}
							buffering: {
								description: """
	Buffering holds the buffering middleware configuration.
	This middleware retries or limits the size of requests that can be forwarded to backends.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/buffering/#maxrequestbodybytes
	"""
								properties: {
									maxRequestBodyBytes: {
										description: """
	MaxRequestBodyBytes defines the maximum allowed body size for the request (in bytes).
	If the request exceeds the allowed size, it is not forwarded to the service, and the client gets a 413 (Request Entity Too Large) response.
	Default: 0 (no maximum).
	"""
										format: "int64"
										type:   "integer"
									}
									maxResponseBodyBytes: {
										description: """
	MaxResponseBodyBytes defines the maximum allowed response size from the service (in bytes).
	If the response exceeds the allowed size, it is not forwarded to the client. The client gets a 500 (Internal Server Error) response instead.
	Default: 0 (no maximum).
	"""
										format: "int64"
										type:   "integer"
									}
									memRequestBodyBytes: {
										description: """
	MemRequestBodyBytes defines the threshold (in bytes) from which the request will be buffered on disk instead of in memory.
	Default: 1048576 (1Mi).
	"""
										format: "int64"
										type:   "integer"
									}
									memResponseBodyBytes: {
										description: """
	MemResponseBodyBytes defines the threshold (in bytes) from which the response will be buffered on disk instead of in memory.
	Default: 1048576 (1Mi).
	"""
										format: "int64"
										type:   "integer"
									}
									retryExpression: {
										description: """
	RetryExpression defines the retry conditions.
	It is a logical combination of functions with operators AND (&&) and OR (||).
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/buffering/#retryexpression
	"""
										type: "string"
									}
								}
								type: "object"
							}
							chain: {
								description: """
	Chain holds the configuration of the chain middleware.
	This middleware enables to define reusable combinations of other pieces of middleware.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/chain/
	"""
								properties: middlewares: {
									description: "Middlewares is the list of MiddlewareRef which composes the chain."
									items: {
										description: "MiddlewareRef is a reference to a Middleware resource."
										properties: {
											name: {
												description: "Name defines the name of the referenced Middleware resource."
												type:        "string"
											}
											namespace: {
												description: "Namespace defines the namespace of the referenced Middleware resource."
												type:        "string"
											}
										}
										required: ["name"]
										type: "object"
									}
									type: "array"
								}
								type: "object"
							}
							circuitBreaker: {
								description: "CircuitBreaker holds the circuit breaker configuration."
								properties: {
									checkPeriod: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "CheckPeriod is the interval between successive checks of the circuit breaker condition (when in standby state)."
										"x-kubernetes-int-or-string": true
									}
									expression: {
										description: "Expression is the condition that triggers the tripped state."
										type:        "string"
									}
									fallbackDuration: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "FallbackDuration is the duration for which the circuit breaker will wait before trying to recover (from a tripped state)."
										"x-kubernetes-int-or-string": true
									}
									recoveryDuration: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "RecoveryDuration is the duration for which the circuit breaker will try to recover (as soon as it is in recovering state)."
										"x-kubernetes-int-or-string": true
									}
									responseCode: {
										description: "ResponseCode is the status code that the circuit breaker will return while it is in the open state."
										type:        "integer"
									}
								}
								type: "object"
							}
							compress: {
								description: """
	Compress holds the compress middleware configuration.
	This middleware compresses responses before sending them to the client, using gzip compression.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/compress/
	"""
								properties: {
									defaultEncoding: {
										description: "DefaultEncoding specifies the default encoding if the `Accept-Encoding` header is not in the request or contains a wildcard (`*`)."
										type:        "string"
									}
									excludedContentTypes: {
										description: """
	ExcludedContentTypes defines the list of content types to compare the Content-Type header of the incoming requests and responses before compressing.
	`application/grpc` is always excluded.
	"""
										items: type: "string"
										type: "array"
									}
									includedContentTypes: {
										description: "IncludedContentTypes defines the list of content types to compare the Content-Type header of the responses before compressing."
										items: type: "string"
										type: "array"
									}
									minResponseBodyBytes: {
										description: """
	MinResponseBodyBytes defines the minimum amount of bytes a response body must have to be compressed.
	Default: 1024.
	"""
										type: "integer"
									}
								}
								type: "object"
							}
							contentType: {
								description: """
	ContentType holds the content-type middleware configuration.
	This middleware exists to enable the correct behavior until at least the default one can be changed in a future version.
	"""
								properties: autoDetect: {
									description: """
	AutoDetect specifies whether to let the `Content-Type` header, if it has not been set by the backend,
	be automatically set to a value derived from the contents of the response.
	Deprecated: AutoDetect option is deprecated, Content-Type middleware is only meant to be used to enable the content-type detection, please remove any usage of this option.
	"""
									type: "boolean"
								}
								type: "object"
							}
							digestAuth: {
								description: """
	DigestAuth holds the digest auth middleware configuration.
	This middleware restricts access to your services to known users.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/digestauth/
	"""
								properties: {
									headerField: {
										description: """
	HeaderField defines a header field to store the authenticated user.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/basicauth/#headerfield
	"""
										type: "string"
									}
									realm: {
										description: """
	Realm allows the protected resources on a server to be partitioned into a set of protection spaces, each with its own authentication scheme.
	Default: traefik.
	"""
										type: "string"
									}
									removeHeader: {
										description: "RemoveHeader defines whether to remove the authorization header before forwarding the request to the backend."
										type:        "boolean"
									}
									secret: {
										description: "Secret is the name of the referenced Kubernetes Secret containing user credentials."
										type:        "string"
									}
								}
								type: "object"
							}
							errors: {
								description: """
	ErrorPage holds the custom error middleware configuration.
	This middleware returns a custom page in lieu of the default, according to configured ranges of HTTP Status codes.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/errorpages/
	"""
								properties: {
									query: {
										description: """
	Query defines the URL for the error page (hosted by service).
	The {status} variable can be used in order to insert the status code in the URL.
	"""
										type: "string"
									}
									service: {
										description: """
	Service defines the reference to a Kubernetes Service that will serve the error page.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/errorpages/#service
	"""
										properties: {
											healthCheck: {
												description: "Healthcheck defines health checks for ExternalName services."
												properties: {
													followRedirects: {
														description: """
	FollowRedirects defines whether redirects should be followed during the health check calls.
	Default: true
	"""
														type: "boolean"
													}
													headers: {
														additionalProperties: type: "string"
														description: "Headers defines custom headers to be sent to the health check endpoint."
														type:        "object"
													}
													hostname: {
														description: "Hostname defines the value of hostname in the Host header of the health check request."
														type:        "string"
													}
													interval: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	Interval defines the frequency of the health check calls.
	Default: 30s
	"""
														"x-kubernetes-int-or-string": true
													}
													method: {
														description: "Method defines the healthcheck method."
														type:        "string"
													}
													mode: {
														description: """
	Mode defines the health check mode.
	If defined to grpc, will use the gRPC health check protocol to probe the server.
	Default: http
	"""
														type: "string"
													}
													path: {
														description: "Path defines the server URL path for the health check endpoint."
														type:        "string"
													}
													port: {
														description: "Port defines the server URL port for the health check endpoint."
														type:        "integer"
													}
													scheme: {
														description: "Scheme replaces the server URL scheme for the health check endpoint."
														type:        "string"
													}
													status: {
														description: "Status defines the expected HTTP status code of the response to the health check request."
														type:        "integer"
													}
													timeout: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	Timeout defines the maximum duration Traefik will wait for a health check request before considering the server unhealthy.
	Default: 5s
	"""
														"x-kubernetes-int-or-string": true
													}
												}
												type: "object"
											}
											kind: {
												description: "Kind defines the kind of the Service."
												enum: [
													"Service",
													"TraefikService",
												]
												type: "string"
											}
											name: {
												description: """
	Name defines the name of the referenced Kubernetes Service or TraefikService.
	The differentiation between the two is specified in the Kind field.
	"""
												type: "string"
											}
											namespace: {
												description: "Namespace defines the namespace of the referenced Kubernetes Service or TraefikService."
												type:        "string"
											}
											nativeLB: {
												description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
												type: "boolean"
											}
											nodePortLB: {
												description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
												type: "boolean"
											}
											passHostHeader: {
												description: """
	PassHostHeader defines whether the client Host header is forwarded to the upstream Kubernetes Service.
	By default, passHostHeader is true.
	"""
												type: "boolean"
											}
											port: {
												anyOf: [{
													type: "integer"
												}, {
													type: "string"
												}]
												description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
												"x-kubernetes-int-or-string": true
											}
											responseForwarding: {
												description: "ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client."
												properties: flushInterval: {
													description: """
	FlushInterval defines the interval, in milliseconds, in between flushes to the client while copying the response body.
	A negative value means to flush immediately after each write to the client.
	This configuration is ignored when ReverseProxy recognizes a response as a streaming response;
	for such responses, writes are flushed to the client immediately.
	Default: 100ms
	"""
													type: "string"
												}
												type: "object"
											}
											scheme: {
												description: """
	Scheme defines the scheme to use for the request to the upstream Kubernetes Service.
	It defaults to https when Kubernetes Service port is 443, http otherwise.
	"""
												type: "string"
											}
											serversTransport: {
												description: """
	ServersTransport defines the name of ServersTransport resource to use.
	It allows to configure the transport between Traefik and your servers.
	Can only be used on a Kubernetes Service.
	"""
												type: "string"
											}
											sticky: {
												description: """
	Sticky defines the sticky sessions configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/services/#sticky-sessions
	"""
												properties: cookie: {
													description: "Cookie defines the sticky cookie configuration."
													properties: {
														httpOnly: {
															description: "HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript."
															type:        "boolean"
														}
														maxAge: {
															description: """
	MaxAge indicates the number of seconds until the cookie expires.
	When set to a negative number, the cookie expires immediately.
	When set to zero, the cookie never expires.
	"""
															type: "integer"
														}
														name: {
															description: "Name defines the Cookie name."
															type:        "string"
														}
														sameSite: {
															description: """
	SameSite defines the same site policy.
	More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
	"""
															type: "string"
														}
														secure: {
															description: "Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS)."
															type:        "boolean"
														}
													}
													type: "object"
												}
												type: "object"
											}
											strategy: {
												description: """
	Strategy defines the load balancing strategy between the servers.
	RoundRobin is the only supported value at the moment.
	"""
												type: "string"
											}
											weight: {
												description: """
	Weight defines the weight and should only be specified when Name references a TraefikService object
	(and to be precise, one that embeds a Weighted Round Robin).
	"""
												type: "integer"
											}
										}
										required: ["name"]
										type: "object"
									}
									status: {
										description: """
	Status defines which status or range of statuses should result in an error page.
	It can be either a status code as a number (500),
	as multiple comma-separated numbers (500,502),
	as ranges by separating two codes with a dash (500-599),
	or a combination of the two (404,418,500-599).
	"""
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							forwardAuth: {
								description: """
	ForwardAuth holds the forward auth middleware configuration.
	This middleware delegates the request authentication to a Service.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/forwardauth/
	"""
								properties: {
									addAuthCookiesToResponse: {
										description: "AddAuthCookiesToResponse defines the list of cookies to copy from the authentication server response to the response."
										items: type: "string"
										type: "array"
									}
									address: {
										description: "Address defines the authentication server address."
										type:        "string"
									}
									authRequestHeaders: {
										description: """
	AuthRequestHeaders defines the list of the headers to copy from the request to the authentication server.
	If not set or empty then all request headers are passed.
	"""
										items: type: "string"
										type: "array"
									}
									authResponseHeaders: {
										description: "AuthResponseHeaders defines the list of headers to copy from the authentication server response and set on forwarded request, replacing any existing conflicting headers."
										items: type: "string"
										type: "array"
									}
									authResponseHeadersRegex: {
										description: """
	AuthResponseHeadersRegex defines the regex to match headers to copy from the authentication server response and set on forwarded request, after stripping all headers that match the regex.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/forwardauth/#authresponseheadersregex
	"""
										type: "string"
									}
									tls: {
										description: "TLS defines the configuration used to secure the connection to the authentication server."
										properties: {
											caOptional: {
												description: "Deprecated: TLS client authentication is a server side option (see https://github.com/golang/go/blob/740a490f71d026bb7d2d13cb8fa2d6d6e0572b70/src/crypto/tls/common.go#L634)."
												type:        "boolean"
											}
											caSecret: {
												description: """
	CASecret is the name of the referenced Kubernetes Secret containing the CA to validate the server certificate.
	The CA certificate is extracted from key `tls.ca` or `ca.crt`.
	"""
												type: "string"
											}
											certSecret: {
												description: """
	CertSecret is the name of the referenced Kubernetes Secret containing the client certificate.
	The client certificate is extracted from the keys `tls.crt` and `tls.key`.
	"""
												type: "string"
											}
											insecureSkipVerify: {
												description: "InsecureSkipVerify defines whether the server certificates should be validated."
												type:        "boolean"
											}
										}
										type: "object"
									}
									trustForwardHeader: {
										description: "TrustForwardHeader defines whether to trust (ie: forward) all X-Forwarded-* headers."
										type:        "boolean"
									}
								}
								type: "object"
							}
							grpcWeb: {
								description: """
	GrpcWeb holds the gRPC web middleware configuration.
	This middleware converts a gRPC web request to an HTTP/2 gRPC request.
	"""
								properties: allowOrigins: {
									description: """
	AllowOrigins is a list of allowable origins.
	Can also be a wildcard origin "*".
	"""
									items: type: "string"
									type: "array"
								}
								type: "object"
							}
							headers: {
								description: """
	Headers holds the headers middleware configuration.
	This middleware manages the requests and responses headers.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/headers/#customrequestheaders
	"""
								properties: {
									accessControlAllowCredentials: {
										description: "AccessControlAllowCredentials defines whether the request can include user credentials."
										type:        "boolean"
									}
									accessControlAllowHeaders: {
										description: "AccessControlAllowHeaders defines the Access-Control-Request-Headers values sent in preflight response."
										items: type: "string"
										type: "array"
									}
									accessControlAllowMethods: {
										description: "AccessControlAllowMethods defines the Access-Control-Request-Method values sent in preflight response."
										items: type: "string"
										type: "array"
									}
									accessControlAllowOriginList: {
										description: "AccessControlAllowOriginList is a list of allowable origins. Can also be a wildcard origin \"*\"."
										items: type: "string"
										type: "array"
									}
									accessControlAllowOriginListRegex: {
										description: "AccessControlAllowOriginListRegex is a list of allowable origins written following the Regular Expression syntax (https://golang.org/pkg/regexp/)."
										items: type: "string"
										type: "array"
									}
									accessControlExposeHeaders: {
										description: "AccessControlExposeHeaders defines the Access-Control-Expose-Headers values sent in preflight response."
										items: type: "string"
										type: "array"
									}
									accessControlMaxAge: {
										description: "AccessControlMaxAge defines the time that a preflight request may be cached."
										format:      "int64"
										type:        "integer"
									}
									addVaryHeader: {
										description: "AddVaryHeader defines whether the Vary header is automatically added/updated when the AccessControlAllowOriginList is set."
										type:        "boolean"
									}
									allowedHosts: {
										description: "AllowedHosts defines the fully qualified list of allowed domain names."
										items: type: "string"
										type: "array"
									}
									browserXssFilter: {
										description: "BrowserXSSFilter defines whether to add the X-XSS-Protection header with the value 1; mode=block."
										type:        "boolean"
									}
									contentSecurityPolicy: {
										description: "ContentSecurityPolicy defines the Content-Security-Policy header value."
										type:        "string"
									}
									contentSecurityPolicyReportOnly: {
										description: "ContentSecurityPolicyReportOnly defines the Content-Security-Policy-Report-Only header value."
										type:        "string"
									}
									contentTypeNosniff: {
										description: "ContentTypeNosniff defines whether to add the X-Content-Type-Options header with the nosniff value."
										type:        "boolean"
									}
									customBrowserXSSValue: {
										description: """
	CustomBrowserXSSValue defines the X-XSS-Protection header value.
	This overrides the BrowserXssFilter option.
	"""
										type: "string"
									}
									customFrameOptionsValue: {
										description: """
	CustomFrameOptionsValue defines the X-Frame-Options header value.
	This overrides the FrameDeny option.
	"""
										type: "string"
									}
									customRequestHeaders: {
										additionalProperties: type: "string"
										description: "CustomRequestHeaders defines the header names and values to apply to the request."
										type:        "object"
									}
									customResponseHeaders: {
										additionalProperties: type: "string"
										description: "CustomResponseHeaders defines the header names and values to apply to the response."
										type:        "object"
									}
									featurePolicy: {
										description: "Deprecated: FeaturePolicy option is deprecated, please use PermissionsPolicy instead."
										type:        "string"
									}
									forceSTSHeader: {
										description: "ForceSTSHeader defines whether to add the STS header even when the connection is HTTP."
										type:        "boolean"
									}
									frameDeny: {
										description: "FrameDeny defines whether to add the X-Frame-Options header with the DENY value."
										type:        "boolean"
									}
									hostsProxyHeaders: {
										description: "HostsProxyHeaders defines the header keys that may hold a proxied hostname value for the request."
										items: type: "string"
										type: "array"
									}
									isDevelopment: {
										description: """
	IsDevelopment defines whether to mitigate the unwanted effects of the AllowedHosts, SSL, and STS options when developing.
	Usually testing takes place using HTTP, not HTTPS, and on localhost, not your production domain.
	If you would like your development environment to mimic production with complete Host blocking, SSL redirects,
	and STS headers, leave this as false.
	"""
										type: "boolean"
									}
									permissionsPolicy: {
										description: """
	PermissionsPolicy defines the Permissions-Policy header value.
	This allows sites to control browser features.
	"""
										type: "string"
									}
									publicKey: {
										description: "PublicKey is the public key that implements HPKP to prevent MITM attacks with forged certificates."
										type:        "string"
									}
									referrerPolicy: {
										description: """
	ReferrerPolicy defines the Referrer-Policy header value.
	This allows sites to control whether browsers forward the Referer header to other sites.
	"""
										type: "string"
									}
									sslForceHost: {
										description: "Deprecated: SSLForceHost option is deprecated, please use RedirectRegex instead."
										type:        "boolean"
									}
									sslHost: {
										description: "Deprecated: SSLHost option is deprecated, please use RedirectRegex instead."
										type:        "string"
									}
									sslProxyHeaders: {
										additionalProperties: type: "string"
										description: """
	SSLProxyHeaders defines the header keys with associated values that would indicate a valid HTTPS request.
	It can be useful when using other proxies (example: "X-Forwarded-Proto": "https").
	"""
										type: "object"
									}
									sslRedirect: {
										description: "Deprecated: SSLRedirect option is deprecated, please use EntryPoint redirection or RedirectScheme instead."
										type:        "boolean"
									}
									sslTemporaryRedirect: {
										description: "Deprecated: SSLTemporaryRedirect option is deprecated, please use EntryPoint redirection or RedirectScheme instead."
										type:        "boolean"
									}
									stsIncludeSubdomains: {
										description: "STSIncludeSubdomains defines whether the includeSubDomains directive is appended to the Strict-Transport-Security header."
										type:        "boolean"
									}
									stsPreload: {
										description: "STSPreload defines whether the preload flag is appended to the Strict-Transport-Security header."
										type:        "boolean"
									}
									stsSeconds: {
										description: """
	STSSeconds defines the max-age of the Strict-Transport-Security header.
	If set to 0, the header is not set.
	"""
										format: "int64"
										type:   "integer"
									}
								}
								type: "object"
							}
							inFlightReq: {
								description: """
	InFlightReq holds the in-flight request middleware configuration.
	This middleware limits the number of requests being processed and served concurrently.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/inflightreq/
	"""
								properties: {
									amount: {
										description: """
	Amount defines the maximum amount of allowed simultaneous in-flight request.
	The middleware responds with HTTP 429 Too Many Requests if there are already amount requests in progress (based on the same sourceCriterion strategy).
	"""
										format: "int64"
										type:   "integer"
									}
									sourceCriterion: {
										description: """
	SourceCriterion defines what criterion is used to group requests as originating from a common source.
	If several strategies are defined at the same time, an error will be raised.
	If none are set, the default is to use the requestHost.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/inflightreq/#sourcecriterion
	"""
										properties: {
											ipStrategy: {
												description: """
	IPStrategy holds the IP strategy configuration used by Traefik to determine the client IP.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/ipallowlist/#ipstrategy
	"""
												properties: {
													depth: {
														description: "Depth tells Traefik to use the X-Forwarded-For header and take the IP located at the depth position (starting from the right)."
														type:        "integer"
													}
													excludedIPs: {
														description: "ExcludedIPs configures Traefik to scan the X-Forwarded-For header and select the first IP not in the list."
														items: type: "string"
														type: "array"
													}
												}
												type: "object"
											}
											requestHeaderName: {
												description: "RequestHeaderName defines the name of the header used to group incoming requests."
												type:        "string"
											}
											requestHost: {
												description: "RequestHost defines whether to consider the request Host as the source."
												type:        "boolean"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
							ipAllowList: {
								description: """
	IPAllowList holds the IP allowlist middleware configuration.
	This middleware limits allowed requests based on the client IP.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/ipallowlist/
	"""
								properties: {
									ipStrategy: {
										description: """
	IPStrategy holds the IP strategy configuration used by Traefik to determine the client IP.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/ipallowlist/#ipstrategy
	"""
										properties: {
											depth: {
												description: "Depth tells Traefik to use the X-Forwarded-For header and take the IP located at the depth position (starting from the right)."
												type:        "integer"
											}
											excludedIPs: {
												description: "ExcludedIPs configures Traefik to scan the X-Forwarded-For header and select the first IP not in the list."
												items: type: "string"
												type: "array"
											}
										}
										type: "object"
									}
									rejectStatusCode: {
										description: """
	RejectStatusCode defines the HTTP status code used for refused requests.
	If not set, the default is 403 (Forbidden).
	"""
										type: "integer"
									}
									sourceRange: {
										description: "SourceRange defines the set of allowed IPs (or ranges of allowed IPs by using CIDR notation)."
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							ipWhiteList: {
								description: "Deprecated: please use IPAllowList instead."
								properties: {
									ipStrategy: {
										description: """
	IPStrategy holds the IP strategy configuration used by Traefik to determine the client IP.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/ipallowlist/#ipstrategy
	"""
										properties: {
											depth: {
												description: "Depth tells Traefik to use the X-Forwarded-For header and take the IP located at the depth position (starting from the right)."
												type:        "integer"
											}
											excludedIPs: {
												description: "ExcludedIPs configures Traefik to scan the X-Forwarded-For header and select the first IP not in the list."
												items: type: "string"
												type: "array"
											}
										}
										type: "object"
									}
									sourceRange: {
										description: "SourceRange defines the set of allowed IPs (or ranges of allowed IPs by using CIDR notation). Required."
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							passTLSClientCert: {
								description: """
	PassTLSClientCert holds the pass TLS client cert middleware configuration.
	This middleware adds the selected data from the passed client TLS certificate to a header.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/passtlsclientcert/
	"""
								properties: {
									info: {
										description: "Info selects the specific client certificate details you want to add to the X-Forwarded-Tls-Client-Cert-Info header."
										properties: {
											issuer: {
												description: "Issuer defines the client certificate issuer details to add to the X-Forwarded-Tls-Client-Cert-Info header."
												properties: {
													commonName: {
														description: "CommonName defines whether to add the organizationalUnit information into the issuer."
														type:        "boolean"
													}
													country: {
														description: "Country defines whether to add the country information into the issuer."
														type:        "boolean"
													}
													domainComponent: {
														description: "DomainComponent defines whether to add the domainComponent information into the issuer."
														type:        "boolean"
													}
													locality: {
														description: "Locality defines whether to add the locality information into the issuer."
														type:        "boolean"
													}
													organization: {
														description: "Organization defines whether to add the organization information into the issuer."
														type:        "boolean"
													}
													province: {
														description: "Province defines whether to add the province information into the issuer."
														type:        "boolean"
													}
													serialNumber: {
														description: "SerialNumber defines whether to add the serialNumber information into the issuer."
														type:        "boolean"
													}
												}
												type: "object"
											}
											notAfter: {
												description: "NotAfter defines whether to add the Not After information from the Validity part."
												type:        "boolean"
											}
											notBefore: {
												description: "NotBefore defines whether to add the Not Before information from the Validity part."
												type:        "boolean"
											}
											sans: {
												description: "Sans defines whether to add the Subject Alternative Name information from the Subject Alternative Name part."
												type:        "boolean"
											}
											serialNumber: {
												description: "SerialNumber defines whether to add the client serialNumber information."
												type:        "boolean"
											}
											subject: {
												description: "Subject defines the client certificate subject details to add to the X-Forwarded-Tls-Client-Cert-Info header."
												properties: {
													commonName: {
														description: "CommonName defines whether to add the organizationalUnit information into the subject."
														type:        "boolean"
													}
													country: {
														description: "Country defines whether to add the country information into the subject."
														type:        "boolean"
													}
													domainComponent: {
														description: "DomainComponent defines whether to add the domainComponent information into the subject."
														type:        "boolean"
													}
													locality: {
														description: "Locality defines whether to add the locality information into the subject."
														type:        "boolean"
													}
													organization: {
														description: "Organization defines whether to add the organization information into the subject."
														type:        "boolean"
													}
													organizationalUnit: {
														description: "OrganizationalUnit defines whether to add the organizationalUnit information into the subject."
														type:        "boolean"
													}
													province: {
														description: "Province defines whether to add the province information into the subject."
														type:        "boolean"
													}
													serialNumber: {
														description: "SerialNumber defines whether to add the serialNumber information into the subject."
														type:        "boolean"
													}
												}
												type: "object"
											}
										}
										type: "object"
									}
									pem: {
										description: "PEM sets the X-Forwarded-Tls-Client-Cert header with the certificate."
										type:        "boolean"
									}
								}
								type: "object"
							}
							plugin: {
								additionalProperties: "x-kubernetes-preserve-unknown-fields": true
								description: """
	Plugin defines the middleware plugin configuration.
	More info: https://doc.traefik.io/traefik/plugins/
	"""
								type: "object"
							}
							rateLimit: {
								description: """
	RateLimit holds the rate limit configuration.
	This middleware ensures that services will receive a fair amount of requests, and allows one to define what fair is.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/ratelimit/
	"""
								properties: {
									average: {
										description: """
	Average is the maximum rate, by default in requests/s, allowed for the given source.
	It defaults to 0, which means no rate limiting.
	The rate is actually defined by dividing Average by Period. So for a rate below 1req/s,
	one needs to define a Period larger than a second.
	"""
										format: "int64"
										type:   "integer"
									}
									burst: {
										description: """
	Burst is the maximum number of requests allowed to arrive in the same arbitrarily small period of time.
	It defaults to 1.
	"""
										format: "int64"
										type:   "integer"
									}
									period: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description: """
	Period, in combination with Average, defines the actual maximum rate, such as:
	r = Average / Period. It defaults to a second.
	"""
										"x-kubernetes-int-or-string": true
									}
									sourceCriterion: {
										description: """
	SourceCriterion defines what criterion is used to group requests as originating from a common source.
	If several strategies are defined at the same time, an error will be raised.
	If none are set, the default is to use the request's remote address field (as an ipStrategy).
	"""
										properties: {
											ipStrategy: {
												description: """
	IPStrategy holds the IP strategy configuration used by Traefik to determine the client IP.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/ipallowlist/#ipstrategy
	"""
												properties: {
													depth: {
														description: "Depth tells Traefik to use the X-Forwarded-For header and take the IP located at the depth position (starting from the right)."
														type:        "integer"
													}
													excludedIPs: {
														description: "ExcludedIPs configures Traefik to scan the X-Forwarded-For header and select the first IP not in the list."
														items: type: "string"
														type: "array"
													}
												}
												type: "object"
											}
											requestHeaderName: {
												description: "RequestHeaderName defines the name of the header used to group incoming requests."
												type:        "string"
											}
											requestHost: {
												description: "RequestHost defines whether to consider the request Host as the source."
												type:        "boolean"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
							redirectRegex: {
								description: """
	RedirectRegex holds the redirect regex middleware configuration.
	This middleware redirects a request using regex matching and replacement.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/redirectregex/#regex
	"""
								properties: {
									permanent: {
										description: "Permanent defines whether the redirection is permanent (301)."
										type:        "boolean"
									}
									regex: {
										description: "Regex defines the regex used to match and capture elements from the request URL."
										type:        "string"
									}
									replacement: {
										description: "Replacement defines how to modify the URL to have the new target URL."
										type:        "string"
									}
								}
								type: "object"
							}
							redirectScheme: {
								description: """
	RedirectScheme holds the redirect scheme middleware configuration.
	This middleware redirects requests from a scheme/port to another.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/redirectscheme/
	"""
								properties: {
									permanent: {
										description: "Permanent defines whether the redirection is permanent (301)."
										type:        "boolean"
									}
									port: {
										description: "Port defines the port of the new URL."
										type:        "string"
									}
									scheme: {
										description: "Scheme defines the scheme of the new URL."
										type:        "string"
									}
								}
								type: "object"
							}
							replacePath: {
								description: """
	ReplacePath holds the replace path middleware configuration.
	This middleware replaces the path of the request URL and store the original path in an X-Replaced-Path header.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/replacepath/
	"""
								properties: path: {
									description: "Path defines the path to use as replacement in the request URL."
									type:        "string"
								}
								type: "object"
							}
							replacePathRegex: {
								description: """
	ReplacePathRegex holds the replace path regex middleware configuration.
	This middleware replaces the path of a URL using regex matching and replacement.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/replacepathregex/
	"""
								properties: {
									regex: {
										description: "Regex defines the regular expression used to match and capture the path from the request URL."
										type:        "string"
									}
									replacement: {
										description: "Replacement defines the replacement path format, which can include captured variables."
										type:        "string"
									}
								}
								type: "object"
							}
							retry: {
								description: """
	Retry holds the retry middleware configuration.
	This middleware reissues requests a given number of times to a backend server if that server does not reply.
	As soon as the server answers, the middleware stops retrying, regardless of the response status.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/retry/
	"""
								properties: {
									attempts: {
										description: "Attempts defines how many times the request should be retried."
										type:        "integer"
									}
									initialInterval: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description: """
	InitialInterval defines the first wait time in the exponential backoff series.
	The maximum interval is calculated as twice the initialInterval.
	If unspecified, requests will be retried immediately.
	The value of initialInterval should be provided in seconds or as a valid duration format,
	see https://pkg.go.dev/time#ParseDuration.
	"""
										"x-kubernetes-int-or-string": true
									}
								}
								type: "object"
							}
							stripPrefix: {
								description: """
	StripPrefix holds the strip prefix middleware configuration.
	This middleware removes the specified prefixes from the URL path.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/stripprefix/
	"""
								properties: {
									forceSlash: {
										description: """
	Deprecated: ForceSlash option is deprecated, please remove any usage of this option.
	ForceSlash ensures that the resulting stripped path is not the empty string, by replacing it with / when necessary.
	Default: true.
	"""
										type: "boolean"
									}
									prefixes: {
										description: "Prefixes defines the prefixes to strip from the request URL."
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							stripPrefixRegex: {
								description: """
	StripPrefixRegex holds the strip prefix regex middleware configuration.
	This middleware removes the matching prefixes from the URL path.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/http/stripprefixregex/
	"""
								properties: regex: {
									description: "Regex defines the regular expression to match the path prefix from the request URL."
									items: type: "string"
									type: "array"
								}
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "middlewaretcps.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "MiddlewareTCP"
			listKind: "MiddlewareTCPList"
			plural:   "middlewaretcps"
			singular: "middlewaretcp"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					MiddlewareTCP is the CRD implementation of a Traefik TCP middleware.
					More info: https://doc.traefik.io/traefik/v3.1/middlewares/overview/
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "MiddlewareTCPSpec defines the desired state of a MiddlewareTCP."
						properties: {
							inFlightConn: {
								description: "InFlightConn defines the InFlightConn middleware configuration."
								properties: amount: {
									description: """
	Amount defines the maximum amount of allowed simultaneous connections.
	The middleware closes the connection if there are already amount connections opened.
	"""
									format: "int64"
									type:   "integer"
								}
								type: "object"
							}
							ipAllowList: {
								description: """
	IPAllowList defines the IPAllowList middleware configuration.
	This middleware accepts/refuses connections based on the client IP.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/tcp/ipallowlist/
	"""
								properties: sourceRange: {
									description: "SourceRange defines the allowed IPs (or ranges of allowed IPs by using CIDR notation)."
									items: type: "string"
									type: "array"
								}
								type: "object"
							}
							ipWhiteList: {
								description: """
	IPWhiteList defines the IPWhiteList middleware configuration.
	This middleware accepts/refuses connections based on the client IP.
	Deprecated: please use IPAllowList instead.
	More info: https://doc.traefik.io/traefik/v3.1/middlewares/tcp/ipwhitelist/
	"""
								properties: sourceRange: {
									description: "SourceRange defines the allowed IPs (or ranges of allowed IPs by using CIDR notation)."
									items: type: "string"
									type: "array"
								}
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "serverstransports.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "ServersTransport"
			listKind: "ServersTransportList"
			plural:   "serverstransports"
			singular: "serverstransport"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					ServersTransport is the CRD implementation of a ServersTransport.
					If no serversTransport is specified, the default@internal will be used.
					The default@internal serversTransport is created from the static configuration.
					More info: https://doc.traefik.io/traefik/v3.1/routing/services/#serverstransport_1
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "ServersTransportSpec defines the desired state of a ServersTransport."
						properties: {
							certificatesSecrets: {
								description: "CertificatesSecrets defines a list of secret storing client certificates for mTLS."
								items: type: "string"
								type: "array"
							}
							disableHTTP2: {
								description: "DisableHTTP2 disables HTTP/2 for connections with backend servers."
								type:        "boolean"
							}
							forwardingTimeouts: {
								description: "ForwardingTimeouts defines the timeouts for requests forwarded to the backend servers."
								properties: {
									dialTimeout: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "DialTimeout is the amount of time to wait until a connection to a backend server can be established."
										"x-kubernetes-int-or-string": true
									}
									idleConnTimeout: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "IdleConnTimeout is the maximum period for which an idle HTTP keep-alive connection will remain open before closing itself."
										"x-kubernetes-int-or-string": true
									}
									pingTimeout: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "PingTimeout is the timeout after which the HTTP/2 connection will be closed if a response to ping is not received."
										"x-kubernetes-int-or-string": true
									}
									readIdleTimeout: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "ReadIdleTimeout is the timeout after which a health check using ping frame will be carried out if no frame is received on the HTTP/2 connection."
										"x-kubernetes-int-or-string": true
									}
									responseHeaderTimeout: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description:                  "ResponseHeaderTimeout is the amount of time to wait for a server's response headers after fully writing the request (including its body, if any)."
										"x-kubernetes-int-or-string": true
									}
								}
								type: "object"
							}
							insecureSkipVerify: {
								description: "InsecureSkipVerify disables SSL certificate verification."
								type:        "boolean"
							}
							maxIdleConnsPerHost: {
								description: "MaxIdleConnsPerHost controls the maximum idle (keep-alive) to keep per-host."
								type:        "integer"
							}
							peerCertURI: {
								description: "PeerCertURI defines the peer cert URI used to match against SAN URI during the peer certificate verification."
								type:        "string"
							}
							rootCAsSecrets: {
								description: "RootCAsSecrets defines a list of CA secret used to validate self-signed certificate."
								items: type: "string"
								type: "array"
							}
							serverName: {
								description: "ServerName defines the server name used to contact the server."
								type:        "string"
							}
							spiffe: {
								description: "Spiffe defines the SPIFFE configuration."
								properties: {
									ids: {
										description: "IDs defines the allowed SPIFFE IDs (takes precedence over the SPIFFE TrustDomain)."
										items: type: "string"
										type: "array"
									}
									trustDomain: {
										description: "TrustDomain defines the allowed SPIFFE trust domain."
										type:        "string"
									}
								}
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "serverstransporttcps.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "ServersTransportTCP"
			listKind: "ServersTransportTCPList"
			plural:   "serverstransporttcps"
			singular: "serverstransporttcp"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					ServersTransportTCP is the CRD implementation of a TCPServersTransport.
					If no tcpServersTransport is specified, a default one named default@internal will be used.
					The default@internal tcpServersTransport can be configured in the static configuration.
					More info: https://doc.traefik.io/traefik/v3.1/routing/services/#serverstransport_3
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "ServersTransportTCPSpec defines the desired state of a ServersTransportTCP."
						properties: {
							dialKeepAlive: {
								anyOf: [{
									type: "integer"
								}, {
									type: "string"
								}]
								description:                  "DialKeepAlive is the interval between keep-alive probes for an active network connection. If zero, keep-alive probes are sent with a default value (currently 15 seconds), if supported by the protocol and operating system. Network protocols or operating systems that do not support keep-alives ignore this field. If negative, keep-alive probes are disabled."
								"x-kubernetes-int-or-string": true
							}
							dialTimeout: {
								anyOf: [{
									type: "integer"
								}, {
									type: "string"
								}]
								description:                  "DialTimeout is the amount of time to wait until a connection to a backend server can be established."
								"x-kubernetes-int-or-string": true
							}
							terminationDelay: {
								anyOf: [{
									type: "integer"
								}, {
									type: "string"
								}]
								description:                  "TerminationDelay defines the delay to wait before fully terminating the connection, after one connected peer has closed its writing capability."
								"x-kubernetes-int-or-string": true
							}
							tls: {
								description: "TLS defines the TLS configuration"
								properties: {
									certificatesSecrets: {
										description: "CertificatesSecrets defines a list of secret storing client certificates for mTLS."
										items: type: "string"
										type: "array"
									}
									insecureSkipVerify: {
										description: "InsecureSkipVerify disables TLS certificate verification."
										type:        "boolean"
									}
									peerCertURI: {
										description: """
	MaxIdleConnsPerHost controls the maximum idle (keep-alive) to keep per-host.
	PeerCertURI defines the peer cert URI used to match against SAN URI during the peer certificate verification.
	"""
										type: "string"
									}
									rootCAsSecrets: {
										description: "RootCAsSecrets defines a list of CA secret used to validate self-signed certificates."
										items: type: "string"
										type: "array"
									}
									serverName: {
										description: "ServerName defines the server name used to contact the server."
										type:        "string"
									}
									spiffe: {
										description: "Spiffe defines the SPIFFE configuration."
										properties: {
											ids: {
												description: "IDs defines the allowed SPIFFE IDs (takes precedence over the SPIFFE TrustDomain)."
												items: type: "string"
												type: "array"
											}
											trustDomain: {
												description: "TrustDomain defines the allowed SPIFFE trust domain."
												type:        "string"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "tlsoptions.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "TLSOption"
			listKind: "TLSOptionList"
			plural:   "tlsoptions"
			singular: "tlsoption"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					TLSOption is the CRD implementation of a Traefik TLS Option, allowing to configure some parameters of the TLS connection.
					More info: https://doc.traefik.io/traefik/v3.1/https/tls/#tls-options
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "TLSOptionSpec defines the desired state of a TLSOption."
						properties: {
							alpnProtocols: {
								description: """
	ALPNProtocols defines the list of supported application level protocols for the TLS handshake, in order of preference.
	More info: https://doc.traefik.io/traefik/v3.1/https/tls/#alpn-protocols
	"""
								items: type: "string"
								type: "array"
							}
							cipherSuites: {
								description: """
	CipherSuites defines the list of supported cipher suites for TLS versions up to TLS 1.2.
	More info: https://doc.traefik.io/traefik/v3.1/https/tls/#cipher-suites
	"""
								items: type: "string"
								type: "array"
							}
							clientAuth: {
								description: "ClientAuth defines the server's policy for TLS Client Authentication."
								properties: {
									clientAuthType: {
										description: "ClientAuthType defines the client authentication type to apply."
										enum: [
											"NoClientCert",
											"RequestClientCert",
											"RequireAnyClientCert",
											"VerifyClientCertIfGiven",
											"RequireAndVerifyClientCert",
										]
										type: "string"
									}
									secretNames: {
										description: "SecretNames defines the names of the referenced Kubernetes Secret storing certificate details."
										items: type: "string"
										type: "array"
									}
								}
								type: "object"
							}
							curvePreferences: {
								description: """
	CurvePreferences defines the preferred elliptic curves in a specific order.
	More info: https://doc.traefik.io/traefik/v3.1/https/tls/#curve-preferences
	"""
								items: type: "string"
								type: "array"
							}
							maxVersion: {
								description: """
	MaxVersion defines the maximum TLS version that Traefik will accept.
	Possible values: VersionTLS10, VersionTLS11, VersionTLS12, VersionTLS13.
	Default: None.
	"""
								type: "string"
							}
							minVersion: {
								description: """
	MinVersion defines the minimum TLS version that Traefik will accept.
	Possible values: VersionTLS10, VersionTLS11, VersionTLS12, VersionTLS13.
	Default: VersionTLS10.
	"""
								type: "string"
							}
							preferServerCipherSuites: {
								description: """
	PreferServerCipherSuites defines whether the server chooses a cipher suite among his own instead of among the client's.
	It is enabled automatically when minVersion or maxVersion is set.
	Deprecated: https://github.com/golang/go/issues/45430
	"""
								type: "boolean"
							}
							sniStrict: {
								description: "SniStrict defines whether Traefik allows connections from clients connections that do not specify a server_name extension."
								type:        "boolean"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "tlsstores.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "TLSStore"
			listKind: "TLSStoreList"
			plural:   "tlsstores"
			singular: "tlsstore"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					TLSStore is the CRD implementation of a Traefik TLS Store.
					For the time being, only the TLSStore named default is supported.
					This means that you cannot have two stores that are named default in different Kubernetes namespaces.
					More info: https://doc.traefik.io/traefik/v3.1/https/tls/#certificates-stores
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "TLSStoreSpec defines the desired state of a TLSStore."
						properties: {
							certificates: {
								description: "Certificates is a list of secret names, each secret holding a key/certificate pair to add to the store."
								items: {
									description: "Certificate holds a secret name for the TLSStore resource."
									properties: secretName: {
										description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
										type:        "string"
									}
									required: ["secretName"]
									type: "object"
								}
								type: "array"
							}
							defaultCertificate: {
								description: "DefaultCertificate defines the default certificate configuration."
								properties: secretName: {
									description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
									type:        "string"
								}
								required: ["secretName"]
								type: "object"
							}
							defaultGeneratedCert: {
								description: "DefaultGeneratedCert defines the default generated certificate configuration."
								properties: {
									domain: {
										description: "Domain is the domain definition for the DefaultCertificate."
										properties: {
											main: {
												description: "Main defines the main domain name."
												type:        "string"
											}
											sans: {
												description: "SANs defines the subject alternative domain names."
												items: type: "string"
												type: "array"
											}
										}
										type: "object"
									}
									resolver: {
										description: "Resolver is the name of the resolver that will be used to issue the DefaultCertificate."
										type:        "string"
									}
								}
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}, {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.14.0"
		name: "traefikservices.traefik.io"
	}
	spec: {
		group: "traefik.io"
		names: {
			kind:     "TraefikService"
			listKind: "TraefikServiceList"
			plural:   "traefikservices"
			singular: "traefikservice"
		}
		scope: "Namespaced"
		versions: [{
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				description: """
					TraefikService is the CRD implementation of a Traefik Service.
					TraefikService object allows to:
					- Apply weight to Services on load-balancing
					- Mirror traffic on services
					More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#kind-traefikservice
					"""
				properties: {
					apiVersion: {
						description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
						type: "string"
					}
					kind: {
						description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "TraefikServiceSpec defines the desired state of a TraefikService."
						properties: {
							mirroring: {
								description: "Mirroring defines the Mirroring service configuration."
								properties: {
									healthCheck: {
										description: "Healthcheck defines health checks for ExternalName services."
										properties: {
											followRedirects: {
												description: """
	FollowRedirects defines whether redirects should be followed during the health check calls.
	Default: true
	"""
												type: "boolean"
											}
											headers: {
												additionalProperties: type: "string"
												description: "Headers defines custom headers to be sent to the health check endpoint."
												type:        "object"
											}
											hostname: {
												description: "Hostname defines the value of hostname in the Host header of the health check request."
												type:        "string"
											}
											interval: {
												anyOf: [{
													type: "integer"
												}, {
													type: "string"
												}]
												description: """
	Interval defines the frequency of the health check calls.
	Default: 30s
	"""
												"x-kubernetes-int-or-string": true
											}
											method: {
												description: "Method defines the healthcheck method."
												type:        "string"
											}
											mode: {
												description: """
	Mode defines the health check mode.
	If defined to grpc, will use the gRPC health check protocol to probe the server.
	Default: http
	"""
												type: "string"
											}
											path: {
												description: "Path defines the server URL path for the health check endpoint."
												type:        "string"
											}
											port: {
												description: "Port defines the server URL port for the health check endpoint."
												type:        "integer"
											}
											scheme: {
												description: "Scheme replaces the server URL scheme for the health check endpoint."
												type:        "string"
											}
											status: {
												description: "Status defines the expected HTTP status code of the response to the health check request."
												type:        "integer"
											}
											timeout: {
												anyOf: [{
													type: "integer"
												}, {
													type: "string"
												}]
												description: """
	Timeout defines the maximum duration Traefik will wait for a health check request before considering the server unhealthy.
	Default: 5s
	"""
												"x-kubernetes-int-or-string": true
											}
										}
										type: "object"
									}
									kind: {
										description: "Kind defines the kind of the Service."
										enum: [
											"Service",
											"TraefikService",
										]
										type: "string"
									}
									maxBodySize: {
										description: """
	MaxBodySize defines the maximum size allowed for the body of the request.
	If the body is larger, the request is not mirrored.
	Default value is -1, which means unlimited size.
	"""
										format: "int64"
										type:   "integer"
									}
									mirrors: {
										description: "Mirrors defines the list of mirrors where Traefik will duplicate the traffic."
										items: {
											description: "MirrorService holds the mirror configuration."
											properties: {
												healthCheck: {
													description: "Healthcheck defines health checks for ExternalName services."
													properties: {
														followRedirects: {
															description: """
	FollowRedirects defines whether redirects should be followed during the health check calls.
	Default: true
	"""
															type: "boolean"
														}
														headers: {
															additionalProperties: type: "string"
															description: "Headers defines custom headers to be sent to the health check endpoint."
															type:        "object"
														}
														hostname: {
															description: "Hostname defines the value of hostname in the Host header of the health check request."
															type:        "string"
														}
														interval: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															description: """
	Interval defines the frequency of the health check calls.
	Default: 30s
	"""
															"x-kubernetes-int-or-string": true
														}
														method: {
															description: "Method defines the healthcheck method."
															type:        "string"
														}
														mode: {
															description: """
	Mode defines the health check mode.
	If defined to grpc, will use the gRPC health check protocol to probe the server.
	Default: http
	"""
															type: "string"
														}
														path: {
															description: "Path defines the server URL path for the health check endpoint."
															type:        "string"
														}
														port: {
															description: "Port defines the server URL port for the health check endpoint."
															type:        "integer"
														}
														scheme: {
															description: "Scheme replaces the server URL scheme for the health check endpoint."
															type:        "string"
														}
														status: {
															description: "Status defines the expected HTTP status code of the response to the health check request."
															type:        "integer"
														}
														timeout: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															description: """
	Timeout defines the maximum duration Traefik will wait for a health check request before considering the server unhealthy.
	Default: 5s
	"""
															"x-kubernetes-int-or-string": true
														}
													}
													type: "object"
												}
												kind: {
													description: "Kind defines the kind of the Service."
													enum: [
														"Service",
														"TraefikService",
													]
													type: "string"
												}
												name: {
													description: """
	Name defines the name of the referenced Kubernetes Service or TraefikService.
	The differentiation between the two is specified in the Kind field.
	"""
													type: "string"
												}
												namespace: {
													description: "Namespace defines the namespace of the referenced Kubernetes Service or TraefikService."
													type:        "string"
												}
												nativeLB: {
													description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
													type: "boolean"
												}
												nodePortLB: {
													description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
													type: "boolean"
												}
												passHostHeader: {
													description: """
	PassHostHeader defines whether the client Host header is forwarded to the upstream Kubernetes Service.
	By default, passHostHeader is true.
	"""
													type: "boolean"
												}
												percent: {
													description: """
	Percent defines the part of the traffic to mirror.
	Supported values: 0 to 100.
	"""
													type: "integer"
												}
												port: {
													anyOf: [{
														type: "integer"
													}, {
														type: "string"
													}]
													description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
													"x-kubernetes-int-or-string": true
												}
												responseForwarding: {
													description: "ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client."
													properties: flushInterval: {
														description: """
	FlushInterval defines the interval, in milliseconds, in between flushes to the client while copying the response body.
	A negative value means to flush immediately after each write to the client.
	This configuration is ignored when ReverseProxy recognizes a response as a streaming response;
	for such responses, writes are flushed to the client immediately.
	Default: 100ms
	"""
														type: "string"
													}
													type: "object"
												}
												scheme: {
													description: """
	Scheme defines the scheme to use for the request to the upstream Kubernetes Service.
	It defaults to https when Kubernetes Service port is 443, http otherwise.
	"""
													type: "string"
												}
												serversTransport: {
													description: """
	ServersTransport defines the name of ServersTransport resource to use.
	It allows to configure the transport between Traefik and your servers.
	Can only be used on a Kubernetes Service.
	"""
													type: "string"
												}
												sticky: {
													description: """
	Sticky defines the sticky sessions configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/services/#sticky-sessions
	"""
													properties: cookie: {
														description: "Cookie defines the sticky cookie configuration."
														properties: {
															httpOnly: {
																description: "HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript."
																type:        "boolean"
															}
															maxAge: {
																description: """
	MaxAge indicates the number of seconds until the cookie expires.
	When set to a negative number, the cookie expires immediately.
	When set to zero, the cookie never expires.
	"""
																type: "integer"
															}
															name: {
																description: "Name defines the Cookie name."
																type:        "string"
															}
															sameSite: {
																description: """
	SameSite defines the same site policy.
	More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
	"""
																type: "string"
															}
															secure: {
																description: "Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS)."
																type:        "boolean"
															}
														}
														type: "object"
													}
													type: "object"
												}
												strategy: {
													description: """
	Strategy defines the load balancing strategy between the servers.
	RoundRobin is the only supported value at the moment.
	"""
													type: "string"
												}
												weight: {
													description: """
	Weight defines the weight and should only be specified when Name references a TraefikService object
	(and to be precise, one that embeds a Weighted Round Robin).
	"""
													type: "integer"
												}
											}
											required: ["name"]
											type: "object"
										}
										type: "array"
									}
									name: {
										description: """
	Name defines the name of the referenced Kubernetes Service or TraefikService.
	The differentiation between the two is specified in the Kind field.
	"""
										type: "string"
									}
									namespace: {
										description: "Namespace defines the namespace of the referenced Kubernetes Service or TraefikService."
										type:        "string"
									}
									nativeLB: {
										description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
										type: "boolean"
									}
									nodePortLB: {
										description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
										type: "boolean"
									}
									passHostHeader: {
										description: """
	PassHostHeader defines whether the client Host header is forwarded to the upstream Kubernetes Service.
	By default, passHostHeader is true.
	"""
										type: "boolean"
									}
									port: {
										anyOf: [{
											type: "integer"
										}, {
											type: "string"
										}]
										description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
										"x-kubernetes-int-or-string": true
									}
									responseForwarding: {
										description: "ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client."
										properties: flushInterval: {
											description: """
	FlushInterval defines the interval, in milliseconds, in between flushes to the client while copying the response body.
	A negative value means to flush immediately after each write to the client.
	This configuration is ignored when ReverseProxy recognizes a response as a streaming response;
	for such responses, writes are flushed to the client immediately.
	Default: 100ms
	"""
											type: "string"
										}
										type: "object"
									}
									scheme: {
										description: """
	Scheme defines the scheme to use for the request to the upstream Kubernetes Service.
	It defaults to https when Kubernetes Service port is 443, http otherwise.
	"""
										type: "string"
									}
									serversTransport: {
										description: """
	ServersTransport defines the name of ServersTransport resource to use.
	It allows to configure the transport between Traefik and your servers.
	Can only be used on a Kubernetes Service.
	"""
										type: "string"
									}
									sticky: {
										description: """
	Sticky defines the sticky sessions configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/services/#sticky-sessions
	"""
										properties: cookie: {
											description: "Cookie defines the sticky cookie configuration."
											properties: {
												httpOnly: {
													description: "HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript."
													type:        "boolean"
												}
												maxAge: {
													description: """
	MaxAge indicates the number of seconds until the cookie expires.
	When set to a negative number, the cookie expires immediately.
	When set to zero, the cookie never expires.
	"""
													type: "integer"
												}
												name: {
													description: "Name defines the Cookie name."
													type:        "string"
												}
												sameSite: {
													description: """
	SameSite defines the same site policy.
	More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
	"""
													type: "string"
												}
												secure: {
													description: "Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS)."
													type:        "boolean"
												}
											}
											type: "object"
										}
										type: "object"
									}
									strategy: {
										description: """
	Strategy defines the load balancing strategy between the servers.
	RoundRobin is the only supported value at the moment.
	"""
										type: "string"
									}
									weight: {
										description: """
	Weight defines the weight and should only be specified when Name references a TraefikService object
	(and to be precise, one that embeds a Weighted Round Robin).
	"""
										type: "integer"
									}
								}
								required: ["name"]
								type: "object"
							}
							weighted: {
								description: "Weighted defines the Weighted Round Robin configuration."
								properties: {
									services: {
										description: "Services defines the list of Kubernetes Service and/or TraefikService to load-balance, with weight."
										items: {
											description: "Service defines an upstream HTTP service to proxy traffic to."
											properties: {
												healthCheck: {
													description: "Healthcheck defines health checks for ExternalName services."
													properties: {
														followRedirects: {
															description: """
	FollowRedirects defines whether redirects should be followed during the health check calls.
	Default: true
	"""
															type: "boolean"
														}
														headers: {
															additionalProperties: type: "string"
															description: "Headers defines custom headers to be sent to the health check endpoint."
															type:        "object"
														}
														hostname: {
															description: "Hostname defines the value of hostname in the Host header of the health check request."
															type:        "string"
														}
														interval: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															description: """
	Interval defines the frequency of the health check calls.
	Default: 30s
	"""
															"x-kubernetes-int-or-string": true
														}
														method: {
															description: "Method defines the healthcheck method."
															type:        "string"
														}
														mode: {
															description: """
	Mode defines the health check mode.
	If defined to grpc, will use the gRPC health check protocol to probe the server.
	Default: http
	"""
															type: "string"
														}
														path: {
															description: "Path defines the server URL path for the health check endpoint."
															type:        "string"
														}
														port: {
															description: "Port defines the server URL port for the health check endpoint."
															type:        "integer"
														}
														scheme: {
															description: "Scheme replaces the server URL scheme for the health check endpoint."
															type:        "string"
														}
														status: {
															description: "Status defines the expected HTTP status code of the response to the health check request."
															type:        "integer"
														}
														timeout: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															description: """
	Timeout defines the maximum duration Traefik will wait for a health check request before considering the server unhealthy.
	Default: 5s
	"""
															"x-kubernetes-int-or-string": true
														}
													}
													type: "object"
												}
												kind: {
													description: "Kind defines the kind of the Service."
													enum: [
														"Service",
														"TraefikService",
													]
													type: "string"
												}
												name: {
													description: """
	Name defines the name of the referenced Kubernetes Service or TraefikService.
	The differentiation between the two is specified in the Kind field.
	"""
													type: "string"
												}
												namespace: {
													description: "Namespace defines the namespace of the referenced Kubernetes Service or TraefikService."
													type:        "string"
												}
												nativeLB: {
													description: """
	NativeLB controls, when creating the load-balancer,
	whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP.
	The Kubernetes Service itself does load-balance to the pods.
	By default, NativeLB is false.
	"""
													type: "boolean"
												}
												nodePortLB: {
													description: """
	NodePortLB controls, when creating the load-balancer,
	whether the LB's children are directly the nodes internal IPs using the nodePort when the service type is NodePort.
	It allows services to be reachable when Traefik runs externally from the Kubernetes cluster but within the same network of the nodes.
	By default, NodePortLB is false.
	"""
													type: "boolean"
												}
												passHostHeader: {
													description: """
	PassHostHeader defines whether the client Host header is forwarded to the upstream Kubernetes Service.
	By default, passHostHeader is true.
	"""
													type: "boolean"
												}
												port: {
													anyOf: [{
														type: "integer"
													}, {
														type: "string"
													}]
													description: """
	Port defines the port of a Kubernetes Service.
	This can be a reference to a named port.
	"""
													"x-kubernetes-int-or-string": true
												}
												responseForwarding: {
													description: "ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client."
													properties: flushInterval: {
														description: """
	FlushInterval defines the interval, in milliseconds, in between flushes to the client while copying the response body.
	A negative value means to flush immediately after each write to the client.
	This configuration is ignored when ReverseProxy recognizes a response as a streaming response;
	for such responses, writes are flushed to the client immediately.
	Default: 100ms
	"""
														type: "string"
													}
													type: "object"
												}
												scheme: {
													description: """
	Scheme defines the scheme to use for the request to the upstream Kubernetes Service.
	It defaults to https when Kubernetes Service port is 443, http otherwise.
	"""
													type: "string"
												}
												serversTransport: {
													description: """
	ServersTransport defines the name of ServersTransport resource to use.
	It allows to configure the transport between Traefik and your servers.
	Can only be used on a Kubernetes Service.
	"""
													type: "string"
												}
												sticky: {
													description: """
	Sticky defines the sticky sessions configuration.
	More info: https://doc.traefik.io/traefik/v3.1/routing/services/#sticky-sessions
	"""
													properties: cookie: {
														description: "Cookie defines the sticky cookie configuration."
														properties: {
															httpOnly: {
																description: "HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript."
																type:        "boolean"
															}
															maxAge: {
																description: """
	MaxAge indicates the number of seconds until the cookie expires.
	When set to a negative number, the cookie expires immediately.
	When set to zero, the cookie never expires.
	"""
																type: "integer"
															}
															name: {
																description: "Name defines the Cookie name."
																type:        "string"
															}
															sameSite: {
																description: """
	SameSite defines the same site policy.
	More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
	"""
																type: "string"
															}
															secure: {
																description: "Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS)."
																type:        "boolean"
															}
														}
														type: "object"
													}
													type: "object"
												}
												strategy: {
													description: """
	Strategy defines the load balancing strategy between the servers.
	RoundRobin is the only supported value at the moment.
	"""
													type: "string"
												}
												weight: {
													description: """
	Weight defines the weight and should only be specified when Name references a TraefikService object
	(and to be precise, one that embeds a Weighted Round Robin).
	"""
													type: "integer"
												}
											}
											required: ["name"]
											type: "object"
										}
										type: "array"
									}
									sticky: {
										description: """
	Sticky defines whether sticky sessions are enabled.
	More info: https://doc.traefik.io/traefik/v3.1/routing/providers/kubernetes-crd/#stickiness-and-load-balancing
	"""
										properties: cookie: {
											description: "Cookie defines the sticky cookie configuration."
											properties: {
												httpOnly: {
													description: "HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript."
													type:        "boolean"
												}
												maxAge: {
													description: """
	MaxAge indicates the number of seconds until the cookie expires.
	When set to a negative number, the cookie expires immediately.
	When set to zero, the cookie never expires.
	"""
													type: "integer"
												}
												name: {
													description: "Name defines the Cookie name."
													type:        "string"
												}
												sameSite: {
													description: """
	SameSite defines the same site policy.
	More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
	"""
													type: "string"
												}
												secure: {
													description: "Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS)."
													type:        "boolean"
												}
											}
											type: "object"
										}
										type: "object"
									}
								}
								type: "object"
							}
						}
						type: "object"
					}
				}
				required: [
					"metadata",
					"spec",
				]
				type: "object"
			}
			served:  true
			storage: true
		}]
	}
}]
