## HOW DNS WORKS?
1. When we enter the url into the browser
2. Browser and OS looks for a cache to find out the IP of the destination server
3. If not found then it goes as follws
4. The resolver server is usually your ISP (Internet Service Provider). All resolvers must know one thing: where to locate the root server.
5. Then the ROOT server indentifies the right the TLD(Top level domain) like .com, .net, .org, etc for the requested url
6. This root server is just one of the 13 root name servers that exist today
7. Root servers sit at the top of the DNS hierarchy(.com, .net, .org)
8. They are scattered around the globe and operated by 12 independent organisations.
11. The .COM server then looks for the Name Server and then NS finds the IP of the destination server

Reference document link: https://howdns.works/ep1/
