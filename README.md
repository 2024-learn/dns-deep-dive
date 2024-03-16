# DNS Deep Dive

## by Nicholas Doropoulos <https://www.udemy.com/course/dns-deep-dive/learn/lecture/28550741#overview>

- __What is DNS?__
- DNS stands for Domain Name System
- The core function of DNS is to map symbolic human-readable names to IP addresses (name resolution)

## DNS Functions
  
### 1. __Name Space:__

- Name space is about how domain names are structured and used in terms of what makes a name valid, what kind of format it should have, what characters and symbols are allowed in it. as well as how names are interpreted
  - __Domain Name Format:__
    - From left to right:
      - Root: represented by a dot `.`
      - Top Level Domain (TLD): e.g. .com, .gov, .net .. etc
      - Second-Level Domain: e.g. google
      - Third-level Domain: e.g. www (more of a naming convention rather than a necessity)
    - TLD and Second-Level Domain form the Zone Apex/ Naked Domain
    - The components of a domain name are known as labels, with the roots being said to have a label of null
    - Each label is a subdomain of its parent domain. i.e. www is a subdomain of example.com
    - There is no maximum number of subdomains that can be used, but the entire FQDN cannot exceed 255 characters(including the periods)
    - DNS names are case insensitive
    - *Fully Qualified Domain Name(FQDN):* the absolute reference to a domain name. e.g `www.example.com.`
    - NOTE: FQDN is not the same thing as a URL, as a URL contains the domain name of a site as well as other information, including the transfer protocol and the path. e.g. <https://www.example.com/learning/>
    - A portion of a domain name such as the host portion of the `www.example.com` domain is known as a *Partially Qualified Domain Name(PQDN)*
      - A partially qualified domain name starts with the hostname, but it may not reach up to the root
    - The other dots outside of the dot representing the root, serve as delimiters, separating the labels of a domain
    - Other cosiderations on a domain name syntax:
      - Each label can be up to 63 characters long
      - The characters are loud and labels can be A through Z, uppercase and lowercase; digits from zero to nine and hyphen. This rule is known as LDH rule letters.
      - Digits hyphen labels may not start or end with a hyphen
      - Top-Level Domain names should not be all numeric
      - There is no maximum limit on the number of subdomains
  - __The DNS Tree__
    - DNS uses a hierarchical name architecture
    - Authority is distributed
    - Name uniqueness is guaranteed
    - Instead of having a singular database if domain names (flattened architecture), we have a globally distributed collection of databases forming a tree-like structure(hierarchical architecture) that is indexed by domain names and where each domain name is essentially just a path in that large tree
    - Administration is decentralized completely and delegeation is handed over to organizations
    - As such many authorities share in the registration nas administrative process and take ove the responsibility of managing their own data.
    - By the same token. every organization administering a domain can further divide it into subdomains
    - And each subdomain can in turn be delegated to other organizations which are then entitled to change the data freely and even subdivide thise sub domains into more sub domains and delegate those
    - *Benefits:*
      - Decentralized administration due to its ability to delegate authority to organizations
      - Easier management flexinility as it allows the namespace to scape and the internet to grow
      - The guarantee that ever domain name is unique
    - The DNS tree consists of root name servers at the top, followed by the TLD, followed by the authoritative name servers.
  - __Root Servers__
    - The root server is the first component of the DNS tree that receives a DNS Query
    - The root server's main job is to reply with a referral to the TLD server to be contacted
    - The first recipient of our request (DNS query) is one of the root servers which sists at the top of the hierarchical DNS tree
    - Upon receiving a query to resolve a specific name, the root server's job is to pass back a referral for a TLD name server based on a TLD extesion of the domain name being requested.
      - e.g, if you type <www.google.com>, the DNS request would be received by a root server, which would pass back a referral with a `com` name server so that the query is sent there next for further processing
    - There are 13 original root name servers, each of which is labelled with a letter from 'A' to 'M'
      - Reference: <https://root-servers.org>
    - There are multiple copies of each root server at over 130 locations all over the world, hosted in multiple secure sites with high bandwidth access to handle the traffic load with 938 root servers being in operation worldwide (as of Feb, 20, 2019)
  - __TLD Servers__
    - The main task of the TLD name server is to provide a referral for an authoritative name server / server that has authority over the requested domain, in this case: yahoo.
    - Each level of the hierarchy provides a piece of the puzzle needed for the requested domain name to be resolved
    - The main categories of TLDs are (Generic)gTLDs and (country code)ccTLDs
    - gTLDs are supposed to reflect the type of industry or space that the organization in ownership of that domain falls into
      - original gTLDs: .arpa, .com, .edu, .gov, .mil, .net, .org
      - additional gTLDs: .aero, .int, .pro .info ...
    - ccTLDs have been created to allow cointries to manage their won namespace and make it easier for their citizens to find the resources they need in the languages they understand
      - e.g .ke, .us, .jp, .za --
    - Countries can also use organizational subdomains in their ccTLDs
      - e.g .co.ke, .co.uk, etc.
    - other TLDs: sTLDs, IDNTLDs, geoTLDs
    - Full list of TLDs can be found at <https://www.iana.org/domains/root/db>
  - __Authoritative Name Server__
    - The hierarchical ame structure in DNS is complemented by a hierarchical authority structure
    - The authoritative name server provided the final answer in a DNS request
    - Linguistically, a domain refers to a sphere of influence governed by an entity that exercises over that domain and is tasked with certain responsibilities
    - In the context of DNS, domain is a particular slice of the protocol's namespace where there is somebody with the authority to manage that segment and with the responsibility to provide answers to DNS requests made for that very segment
    - The entire name hierarchy is divided into such segments of authority. DNS uses a globally distributed system of databases and that system works in conjuction with an equally distributed system os authorities
    - This herarchical authority structure complements the heirachical name structure in DNS and it is not necessary for a different authority to exist at each level of the hierarchy. As in many cases, a single authority may manage a section of the namespace the spans more than one level of the structure. e.g. ICANN manages the root servers and the .int TLD.
    - In short, the authoritative name server is the one holding the DNS name database specific to the requested domain and the one that will complete the name resolution process by providing the IP address mapped to the domain name we have typed in our browser.

### 2. __Name Resolution:__

- The action of converting a domain name into an IP address is referred to as __name resolution__
- __Local name resolution__ occurs locally on the end user's machine without contacting any external servers or systems of any kind
  - In this type of resolution, there are no root servers, TLD servers, or any similar infra.
  - Local name resolution is controlled by the host table, a simple text file consisting of static mappings between IP addresses and host names.
    - The host table is actually a predecessor of DNS, and it was one of the earliest named systems ever created in computing
  - The host table is represented by the host file - in Linux:`/etc/hosts` ; in Windows: `C:\Windows\System32\drivers\etc\hosts`
  - Admin priviledges are required to modify the hosts file
  - Local name resolution is also known as host table name resolution

  ```cat /etc/hosts
  ##
  # Host Database
  #
  # localhost is used to configure the loopback interface
  # when the system is booting.  Do not change this entry.
  ##
  127.0.0.1       localhost loopback
  255.255.255.255 broadcasthost
  ::1             localhost
  ```

  - __Local host file:__
    - Each line defines an association between an IP address and one or more host names
    - Each field is separated by a whitespace which can be any number of space and/or tab characters
    - There are no maximum number of entries, but the bigger the file, the slower the name lookups will be
    - Wildcard (*) entries are not supported, Every domain and subdomain needs to be explicitly defined
    - Everything after the hash(#) symbol until the end of the line is considered a comment and not interpreted by the host table
    - Entirely blank lines are ignored
    - The syntax is virtually identical to the domain name format of DNS.
      - So host names may only contain alphanumerical characters, hyphens and periods;
      - They must begin with an alphanumeric character and end with an alphanumeric character
      - The IP address can be IPv4 or IPv6
      - If required a host may have two separate entries in the file, one for each version of the internet protocol
    - Modifications to the hosts file take effect immediately, (no system or browser restart is needed), except in cases where the file is cached by applications
    - Host Table resolution is based on a flat name architecture which has limitations:
      - Difficulty in scaling
      - Hard to ensure name uniqueness
      - Hard to maintain consistency across an expanding network
    - As a result, host table and its local name resolution eventually gave way to DNS and its hierarchical name resolution
    - Use case of local name resolution:
      - Small local networks
      - Can be used a supplement to DNS in order to improve performance
        - The host table is read before DNS name resolution kicks off. By creating manual mappings of commonly accessed sites on the internet, we can override the entire DNS process entirely and avoid having DNS requests consuming the network's bandwidth. NOTE: This method, however, would need to be used for websites whose IP addresses remain static, otherwise we would need to continuously update the mapping with new IP addresses of the specified sites, which is not practical
      - Can be used for redirecting local domains for various purposes, such as accessing the company's internal resources, or to test local websites in development
      - It can also be used for basic URL filtering. e.g by associating target websites with a PC's loopback address of 127.0.0.1.
        - A dedicated anti-malware software is better suited for this task, though
      - It can be used for bootstrapping the most important hosts on the local network to ensure that names are resolved when DNS is not running, e.g. in the event of a system boots up.
      - It can be used as a fallback last resort method for resolving critical domains in case DNS stops working altogether
    - __Best Practices__
      - Do not create unncessary entries in the hosts file
      - Remember you can associate a single IP address with multiple aliases on a single line
      - Keep the content organized by dividing the mappings into categories based on their purpose and by adding comments where appropriate
      - Use version control
      - Enforce access control so that unauthorized users cannot modify the hosts file. by default, all users with admin priviledges can perform changes
      - Always copy the hosts file before making any changes.
      - Comment out undesired mappings to disable them instead of deleting them outright, it saves time if you wish to reapply them in the future
      - Implement a mechanism to ensure name uniqueness which can be achieved with a custom script
  - __DNS Resolvers__
    - The DNS resolver resolves queries either directly or indirectly
    - The DNS resolver knows about the root servers due to the root hints file it has
    - Not all DNS resolvers support the same features or operate in exactly the same manner
    - The first server that receives the client's request is the DNS resolver, which sits between the client and the rest of the DNS ecosystem
    - Upon receiving the request, the resolver first sees if it can answer the request directly and if not, it assumes the role of the client and it takes upon itself to have the query resolved on behalf of the original client by contacting the root servers and progressing the name resolution process.
    - After receiving the final answer from the requested domain's authoritative name server, the resolver saves the resolve query in its cache and forwards it to the original client.
    - NOTE: the role of the client and server are not mutually exclusive in DNS, as it's possible for systems to assume either role in this case
    - How does the DNS resolver know about the root servers?
      - The resolver has the knowledge of root servers due to its *root hints file* which is where the root servers are stored.
      - <https://www.internic.net/domain/named.root>
      - So long as the resolver has the information included in <https://www.internic.net/domain/named.root> this file, it will be able to contact the root servers whole trying to resolve a domain name for its client
    - In a small office/ home office network, the DNS resolver is typically the router or an IP address provided by the Internet Service Provicer (ISP)
    - `ipconfig /all | findstr "DNS"`(Windows): to get the IP address of your DNS resolver; in Linux you can `cat /etc/resolv.conf`
    - Companies on the other hand, have their own DNS resolver.
    - It is also possible to use an open DNS resolver for your environment as long as a connection to the internet is established
    - Most well known resolvers:
      - Google: 8.8.8.8, 8.8.4.4
      - CloudFlare: 1.1.1.1
      - Quad9: 9.9.9.9
    - There are some differences between DNS resolvers:
      - Some resolvers support EDNS0 (An extension ti the DNS protocol) whereas some others do not.
      - Many resolvers support ngative caching but not all
      - Not all resolvers use the same method in choosing which name servers to contact.
        - The majority of DNS resolvers use a technique called smooth round trip time (SRTT), which is based on the lowest latency
        - Other resolvers select name servers at random
    - Analogy: A customer service rep who keeps providing us with different phone numbers until you finally get to the right depeartment
  - __Iterative Name Resolution:__
    - There are two main resolution types of DNS: Iterative and Recursive.
    - The server's referal includes every single name server contained in its local data. It is up to the client to choose which name server to contact next.
      - Let's say we have a client that sends a DNS query to a server requesting information about a specific domain name.
      - The queried server looks for the requested information on its own local data and if it doesn't have the answer there, it returns a referral containing the names and addresses of the name servers closest to the domain name in the request to allow the resolution process to continue.
    - In iterative resolution, it is the CLIENT's responsibility to keep querying servers until the required information is obtained.
      - The client must iterate by sending a new request to this referred server, which again will return an answer or another referral.
      - The process continues until the correct server is found and an authoritative answer is given. The queries involved in this process are referred to as iterative, while the service responses are known as referrals.
    - Iterative Name Resolution image:
    ![iterative name resolution](https://cdn.ttgtmedia.com/rms/onlineImages/DNS_server_02.jpg)
    ![iterative name resolution](https://lh3.googleusercontent.com/-jjjSSsJ4NI6LpUyzl0qlL46opK_MaUEzBD4SXU1YQtZHESJCGMe2yvE9ZE72AOqj4NFlQDZOirSX7yPz7qLE94st3EjzETHTcVGLAZL2t1bKYVkVRZwU6B1idPOh11pPClma5XZ)
  - __Recursive Name Resolution:__
    - Upon receiving a recursive query, the server checks if it possesses the information requested, in which case, it passes an aswer back to the client.
    - If it doesn't, instead of simply referring to the client with a referral to a point like in iterative resolution, the  server instead assumes the role of the client and it begins looking for the requested information on behalf of the original client.
    - In this type of resolution, the original client gets to send only a single query, which eventually returns the information requested
      - In recursive resolution, it is the SERVER's responsibility to obtain the DNS information requested by the original client
    - Recursive queries cannot be responded to with referrals; instead recursive queries compel the query server to find the requested information on behalf of the original client.
    - Analogy: A customer representative who puts us on hold and takes it upon themselves to look for the information until they find it or fail before returing to us with the answer.

    - Differences between iterative and recursive name resolution: <https://threat.media/definition/what-is-an-iterative-dns-query/>
    - Recursive Name Resolution image:
      ![Recursive Name Resolution](https://lh4.googleusercontent.com/OGbORicB2r8DRnJNSjkw5hgT2rB6po98XUzrEAiazTbc8iub1SMr9o6gMVHKMCTJvkSnkW02MSpW4_P6G3WduM18M__GadEhrx26TRCQufRf0n3CfRGIWncj1RN48-sOMjnxTxUs)
  - __Caching:__
    - The purpose of caching computing is to temporarily store previously acquired data so that future requests for that data can be served faster.
    - in the context of DNS, whenever a name is resolved, the resulting DNS information is cached, so it can be used for subsquent requests that take place. This way, so long as the interesting DNS information remains cached for future requests against the same, data will stop at the system that has cached the data in question. This saves the network bandwidth and any resulting latency in DNS lookups.
    - As soon as the resolver has the authrotative answer, it caches it before forwarding it to the client, which in turn places the resolved data in its own cache as well.
    - As a result in the case of e.g. `www.example.com`, for any future requests against that domain, the client will first consult its cache, which includes any recently resolved DNS information, as well as the mappings in the host table. If the infomation is not there, then the client will then contact the resolver, which will then check its own cache and return the answer to the client, which then caches the information for future reference. If the information, is not available in either of these caches, then the client will then proceed to sending the usual series of iterative requests until it finds the authoritative answer for `www.example.com`
    - Unsuccessful requests resulting in errors are also cached in what is known as 'negative caching'.
    - Caching is so important in DNS that dedicated DNS servers (cache-only DNS srevers) exist with a sole purpose of providing the caching function without having any authority over any domains.
      - They are often present in many network deployments
    - Why is the cache not permanent?
      - Whether intentional or accidental, changes take place in the configuation of DNS name servers, and those changes can result in incorrect responses due to cached information that is no longer valid. e.g if the IP address of `www.example.com` were to change, the cached domain name would not be able to be resolved, resulting in an error
        - The value of the __Time To Live (TTL)__ parameter determines the amount of time DNS information remains cached
    - `ipconfig /displaydns` (Windows): Displays the DNS resolver cache content
    - `ipconfig /flushdns` (Windows): Clears the cache
    - DNS caching in Linux is done by dedicated services, such as the Name Service Caching Daemon (ncsd).
      - first terminal: `sudo ncsd -g`: this command will display the statistics of the DNS cachng daemon
        - `sudo strings /var/cache/nscd/hosts`: displays the DNS information that has been cached
        - `sudo watch -n1 'nscd -g | grep A21 "hosts cache:" | grep "cache hit rate"'`
          - on a second terminal: `export PS1='$`
            - `sudo tcpdump -nni any port 53` (this will display no trafic as the website we are trying to reach is cached)
      - in the first terminal: `sudo nscd -i hosts`
        - You will notice the traffic on the second terminal now as the website is no longer cached, and now when you refresh the browser, the client sends the DNS request since the cached entry is no longer available
    - Other Linux DNS caching services:
      - dnsmasq
      - systemd-resolved
      - unbound
    - Browsers also have their DNS cache. You can clear it by visiting: <chrome://net-internals/#dns>
    - Most but not all DNS resolvers cache recently resolved requests
    - Not all queries are cached, e.g. reverse queries, any resolutions returning data perceived as unreliable or corrupted
    - Negative answers are cached with a different TTL
    - Cache hit/ Cache miss.
      - Cache hit refers to whenever the client finds the information it is looking for inside the cache.
      - Cache miss is the opposite
  - __DNS Name Resolution Workflow:__
    - The FQDN of `www.example.com` is actually `www.example.com.` with the trailing period representing the root. The trailing period is implied so you do not have to type it in thte address bar
    - Not all DNS resolvers use the same method in choosing which name server to contact.
    - The process begins with an end user typing a domain name into their broswer e.g. `www.example.com`
    - Assuming that the browser does not have that information in its cache, it will ask the client's operating system
    - The OS checks its cache and host table for any data on the site.
    - Assuming that is doesn't find any, a recursive query is then sent to the DNS resolver, which first checks its own DNS cache and if there is no information there either, the DNS resolver consults its route hints file and contacts a root name server.
    - The queried root name server sends back a referral containing a list of name servers for the `.com` zone along with their respective IP addresses
    - The DNS resolver then selcts one of those nae servers and sends it an iterative query for the site. the queried `.com` name server responds with a referral containinf a list of name servers which are authoritative for the `example.com` domain
    - The DNS resolver selects one of those name servers and sends it an iterative query for `www.example.com`.
    - The authoritative name server then replies with an authoritative answer containing the IP address of the domain in question
    - The DNS resolver then caches the information and forwards it to the client that had transmitted the recursive query.
    - The client's OS then places the same data in its own cache and then passes it over to the browser, which typically puts the resolve name in its own cache as well.
  - __Reverse Name Resolution:__
    - ref: <https://www.whatsmydns.net/reverse-dns-lookup>
    - A DNS request that is looking for the IP address of a domain name is known as a forward request or forward resolution.
      - Forward resolution: Resolving domain names into their corresponding addresses.
    - Reverse Resolution(rDNS): When you have an IP address and need to find the domain name it is attached to.
      - To accomodate reverse resolution, DNS has a special domain called `in-add.arpa`
        - The `in-addr` part stands for internet address
        - Within that domain is a numerical hierarchy that covers the entire IP address space, and it contains 4 levels of numerical subdomains structured so that each IP address has its own node, and that node can contain an entry that points to the domain name mapped to that address.
        - At each level of the hierarchy are 256 subdomains (0 - 255)
        - The `in-arpa` reverse name resolution covers the entire IPv4 address space and coexists with the domain name hierarchy under the same root
        - The reason why we reverse the octets of the IP address contained in the reverse name is because, unlike the name resolution that proceeds form the least specific to the most specific element going from right to left, IP addresses have the least specific octets on the left and the most specific one on the right. In the interest of mainitaining consistency with the DNS namespace, the octets are thus flipped
      - `ping www.example.com`: forward resolution
      - Reverse resolution using `ping`:
        - `ping -a 8.8.8.8`
      - `dig -x 8.8.8.8`: reverse name lookup
        - `dig -x 8.8.8.8 +noall +answer`: maked the `dig` output more precise.
        - Unlike `ping`, `dig`displays both parts of the mapping: the reverse name and the domain name
      - `nslookup 8.8.4.4`
      - other reverse name lookup tools:
        - <https://mxtoolbox.com/ReverseLookup.aspx>
        - <https://whatismyip.com/reverse-dns-lookup/>
        - <https://tools.iplocation.net/reverse-dns>
    - Reverse name lookups though useful are not critical for the function of the internet so it is not mandatory for organizations to put in place reverse DNS entries for their IP addresses
    - Most common uses for reverse name resolution:
      - Troubleshooting: You might have an IP address and you want to find the domain name that it is associated with.
      - Filtering spam: E-mail servers lookup the IP address of an incoming email and if no valid domain name is found, the message is blocked
      - Logging software: Reverse name lookups enable logging software to display not only IP addresses in the log data, but the human-readable domain names those IP addresses are mapped to.

### 3. __Name Registration:__

- Name registration is how a domain is registered, how its uniqueness is guaranteed, and what are the registration authorities responsible for the name assignment process
  - __Domain Name Registration Hierarchy:__
  - ICANN's main role is to oversee the huge and complex interconnected network of unique identifiers that allow computers on the internet to find one another.
  - Each registry is responsible for allocation IP ranges to ISPs across a specific region.
  - <https://www.iana.org/numbers>
  -
