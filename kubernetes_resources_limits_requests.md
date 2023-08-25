  ### Number decimal representation (memory specification)
  You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: E, P, T, G, M, k. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki
  
  1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization

  400 mebibytes (400Mi)[power of 2 representation] or 400 megabytes (400M)[reqular number representation].

  ### CPU specification
  CPU resources are measured in cpu units. In Kubernetes, 1 CPU unit is equivalent to 1 physical CPU core, or 1 virtual core, depending on whether the node is a physical host or a virtual machine running inside a physical machine.

  0.1 is equivalent to the expression 100m, which can be read as "one hundred millicpu". Some people say "one hundred millicores", and this is understood to mean the same thing.

  Kubernetes doesn't allow you to specify CPU resources with a precision finer than 1m. Because of this, it's useful to specify CPU units less than 1.0 or 1000m using the milliCPU form; for example, 5m rather than 0.005

  
