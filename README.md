# DNS Deep Dive

## by Nicholas Doropoulos <https://www.udemy.com/course/dns-deep-dive/learn/lecture/28550741#overview>

- __What is DNS?__
- DNS stands for Domain Name System
- The core function of DNS is to map symbolic human-readable names to IP addresses (name resolution)

## DNS Functions
  
### 1. __Name Space:__

- Name space is about how domain names are structured and used in terms of what makes a name valid, what kind of format it should have, what characters and symbols are allowed in it, as well as how names are interpreted.
  - __Domain Name Format:__
    - From left to right:
      - Root: represented by a dot `.`
      - Top Level Domain (TLD): e.g. .com, .gov, .net .. etc
      - Second-Level Domain: e.g. google
      - Third-level Domain: e.g. www (more of a naming convention rather than a necessity)
    - TLD and Second-Level Domain form the Zone Apex/ Naked Domain
    - The components of a domain name are known as labels, with the roots being said to have a label of null
    - Each label is a subdomain of its parent domain. i.e. `www` is a subdomain of `example.com`
    - There is no maximum number of subdomains that can be used, but the entire FQDN cannot exceed 255 characters(including the periods)
    - DNS names are case insensitive
    - *Fully Qualified Domain Name(FQDN):* the absolute reference to a domain name. e.g `www.example.com.`
    - NOTE: FQDN is not the same thing as a URL, as a URL contains the domain name of a site as well as other information, including the transfer protocol and the path. e.g. <https://www.example.com/learning/>
    - A portion of a domain name such as the host portion of the `www.example.com` domain is known as a *Partially Qualified Domain Name(PQDN)*
      - A partially qualified domain name starts with the hostname, but it may not reach up to the root
    - The other dots outside of the dot representing the root, serve as delimiters, separating the labels of a domain
    - Other considerations on a domain name syntax:
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
    - Administration is decentralized completely and delegation is handed over to organizations
    - As such many authorities share in the registration nas administrative process and take over the responsibility of managing their own data.
    - By the same token. every organization administering a domain can further divide it into subdomains
    - And each subdomain can in turn be delegated to other organizations which are then entitled to change the data freely and even subdivide these sub domains into more sub domains and delegate those
    - *Benefits:*
      - Decentralized administration due to its ability to delegate authority to organizations
      - Easier management flexibility as it allows the namespace to scape and the internet to grow
      - The guarantee that ever domain name is unique
    - The DNS tree consists of root name servers at the top, followed by the TLD, followed by the authoritative name servers.
  - __Root Servers__
    - The root server is the first component of the DNS tree that receives a DNS Query
    - The root server's main job is to reply with a referral to the TLD server to be contacted
    - The first recipient of our request (DNS query) is one of the root servers which sits at the top of the hierarchical DNS tree
    - Upon receiving a query to resolve a specific name, the root server's job is to pass back a referral for a TLD name server based on a TLD extension of the domain name being requested.
      - e.g, if you type <www.google.com>, the DNS request would be received by a root server, which would pass back a referral with a `com` name server so that the query is sent there next for further processing
    - There are 13 original root name servers, each of which is labeled with a letter from 'A' to 'M'
      - Reference: <https://root-servers.org>
    - There are multiple copies of each root server at over 130 locations all over the world, hosted in multiple secure sites with high bandwidth access to handle the traffic load with 938 root servers being in operation worldwide (as of Feb, 20, 2019)
  - __TLD Servers__
    - The main task of the TLD name server is to provide a referral for an authoritative name server / server that has authority over the requested domain, in this case: yahoo.
    - Each level of the hierarchy provides a piece of the puzzle needed for the requested domain name to be resolved
    - The main categories of TLDs are (Generic)gTLDs and (country code)ccTLDs
    - gTLDs are supposed to reflect the type of industry or space that the organization in ownership of that domain falls into
      - original gTLDs: .arpa, .com, .edu, .gov, .mil, .net, .org
      - additional gTLDs: .aero, .int, .pro .info ...
    - ccTLDs have been created to allow countries to manage their own namespace and make it easier for their citizens to find the resources they need in the languages they understand
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
    - The entire name hierarchy is divided into such segments of authority. DNS uses a globally distributed system of databases and that system works in conjunction with an equally distributed system of authorities
    - This hierarchical authority structure complements the hierarchical name structure in DNS and it is not necessary for a different authority to exist at each level of the hierarchy. As in many cases, a single authority may manage a section of the namespace that spans more than one level of the structure. e.g. ICANN manages the root servers and the .int TLD.
    - In short, the authoritative name server is the one holding the DNS name database specific to the requested domain and the one that will complete the name resolution process by providing the IP address mapped to the domain name we have typed in our browser.

### 2. __Name Resolution:__

- The action of converting a domain name into an IP address is referred to as __name resolution__
- __Local name resolution__ occurs locally on the end user's machine without contacting any external servers or systems of any kind
  - In this type of resolution, there are no root servers, TLD servers, or any similar infra.
  - Local name resolution is controlled by the host table, a simple text file consisting of static mappings between IP addresses and host names.
    - The host table is actually a predecessor of DNS, and it was one of the earliest named systems ever created in computing
  - The host table is represented by the host file - in Linux:`/etc/hosts` ; in Windows: `C:\Windows\System32\drivers\etc\hosts`
  - Admin privileges are required to modify the hosts file
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
      - Do not create unnecessary entries in the hosts file
      - Remember you can associate a single IP address with multiple aliases on a single line
      - Keep the content organized by dividing the mappings into categories based on their purpose and by adding comments where appropriate
      - Use version control
      - Enforce access control so that unauthorized users cannot modify the hosts file. by default, all users with admin privileges can perform changes
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
    - In a small office/ home office network, the DNS resolver is typically the router or an IP address provided by the Internet Service Provider (ISP)
    - `ipconfig /all | findstr "DNS"`(Windows): to get the IP address of your DNS resolver; in Linux you can `cat /etc/resolv.conf`
    - Companies on the other hand, have their own DNS resolver.
    - It is also possible to use an open DNS resolver for your environment as long as a connection to the internet is established
    - Most well known resolvers:
      - Google: 8.8.8.8, 8.8.4.4
      - CloudFlare: 1.1.1.1
      - Quad9: 9.9.9.9
    - There are some differences between DNS resolvers:
      - Some resolvers support EDNS0 (An extension to the DNS protocol) whereas some others do not.
      - Many resolvers support negative caching but not all
      - Not all resolvers use the same method in choosing which name servers to contact.
        - The majority of DNS resolvers use a technique called smooth round trip time (SRTT), which is based on the lowest latency
        - Other resolvers select name servers at random
    - Analogy: A customer service rep who keeps providing us with different phone numbers until you finally get to the right department
  - __Iterative Name Resolution:__
    - There are two main resolution types of DNS: Iterative and Recursive.
    - The server's referral includes every single name server contained in its local data. It is up to the client to choose which name server to contact next.
      - Let's say we have a client that sends a DNS query to a server requesting information about a specific domain name.
      - The queried server looks for the requested information on its own local data and if it doesn't have the answer there, it returns a referral containing the names and addresses of the name servers closest to the domain name in the request to allow the resolution process to continue.
    - In iterative resolution, it is the CLIENT's responsibility to keep querying servers until the required information is obtained.
      - The client must iterate by sending a new request to this referred server, which again will return an answer or another referral.
      - The process continues until the correct server is found and an authoritative answer is given. The queries involved in this process are referred to as iterative, while the service responses are known as referrals.
    - Iterative Name Resolution image:
    - ![iterative name resolution](https://cdn.ttgtmedia.com/rms/onlineImages/DNS_server_02.jpg)
    -
    - ![iterative name resolution](https://lh3.googleusercontent.com/-jjjSSsJ4NI6LpUyzl0qlL46opK_MaUEzBD4SXU1YQtZHESJCGMe2yvE9ZE72AOqj4NFlQDZOirSX7yPz7qLE94st3EjzETHTcVGLAZL2t1bKYVkVRZwU6B1idPOh11pPClma5XZ)
  - __Recursive Name Resolution:__
    - Upon receiving a recursive query, the server checks if it possesses the information requested, in which case, it passes an answer back to the client.
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
    - in the context of DNS, whenever a name is resolved, the resulting DNS information is cached, so it can be used for subsequent requests that take place. This way, so long as the interesting DNS information remains cached for future requests against the same, data will stop at the system that has cached the data in question. This saves the network bandwidth and any resulting latency in DNS lookups.
    - As soon as the resolver has the authoritative answer, it caches it before forwarding it to the client, which in turn places the resolved data in its own cache as well.
    - As a result in the case of e.g. `www.example.com`, for any future requests against that domain, the client will first consult its cache, which includes any recently resolved DNS information, as well as the mappings in the host table. If the information is not there, then the client will then contact the resolver, which will then check its own cache and return the answer to the client, which then caches the information for future reference. If the information, is not available in either of these caches, then the client will then proceed to sending the usual series of iterative requests until it finds the authoritative answer for `www.example.com`
    - Unsuccessful requests resulting in errors are also cached in what is known as 'negative caching'.
    - Caching is so important in DNS that dedicated DNS servers (cache-only DNS servers) exist with a sole purpose of providing the caching function without having any authority over any domains.
      - They are often present in many network deployments
    - Why is the cache not permanent?
      - Whether intentional or accidental, changes take place in the configuration of DNS name servers, and those changes can result in incorrect responses due to cached information that is no longer valid. e.g if the IP address of `www.example.com` were to change, the cached domain name would not be able to be resolved, resulting in an error
        - The value of the __Time To Live (TTL)__ parameter determines the amount of time DNS information remains cached
    - `ipconfig /displaydns` (Windows): Displays the DNS resolver cache content
    - `ipconfig /flushdns` (Windows): Clears the cache
    - DNS caching in Linux is done by dedicated services, such as the Name Service Caching Daemon (ncsd).
      - first terminal: `sudo ncsd -g`: this command will display the statistics of the DNS caching daemon
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
    - The FQDN of `www.example.com` is actually `www.example.com.` with the trailing period representing the root. The trailing period is implied so you do not have to type it in the address bar
    - Not all DNS resolvers use the same method in choosing which name server to contact.
    - The process begins with an end user typing a domain name into their browser e.g. `www.example.com`
    - Assuming that the browser does not have that information in its cache, it will ask the client's operating system
    - The OS checks its cache and host table for any data on the site.
    - Assuming that it doesn't find any, a recursive query is then sent to the DNS resolver, which first checks its own DNS cache and if there is no information there either, the DNS resolver consults its route hints file and contacts a root name server.
    - The queried root name server sends back a referral containing a list of name servers for the `.com` zone along with their respective IP addresses
    - The DNS resolver then selects one of those name servers and sends it an iterative query for the site. the queried `.com` name server responds with a referral containing a list of name servers which are authoritative for the `example.com` domain
    - The DNS resolver selects one of those name servers and sends it an iterative query for `www.example.com`.
    - The authoritative name server then replies with an authoritative answer containing the IP address of the domain in question
    - The DNS resolver then caches the information and forwards it to the client that had transmitted the recursive query.
    - The client's OS then places the same data in its own cache and then passes it over to the browser, which typically puts the resolve name in its own cache as well.
  - __Reverse Name Resolution:__
    - ref: <https://www.whatsmydns.net/reverse-dns-lookup>
    - A DNS request that is looking for the IP address of a domain name is known as a forward request or forward resolution.
      - Forward resolution: Resolving domain names into their corresponding addresses.
    - Reverse Resolution(rDNS): When you have an IP address and need to find the domain name it is attached to.
      - To accommodate reverse resolution, DNS has a special domain called `in-add.arpa`
        - The `in-addr` part stands for internet address
        - Within that domain is a numerical hierarchy that covers the entire IP address space, and it contains 4 levels of numerical subdomains structured so that each IP address has its own node, and that node can contain an entry that points to the domain name mapped to that address.
        - At each level of the hierarchy are 256 subdomains (0 - 255)
        - The `in-arpa` reverse name resolution covers the entire IPv4 address space and coexists with the domain name hierarchy under the same root
        - The reason why we reverse the octets of the IP address contained in the reverse name is because, unlike the name resolution that proceeds form the least specific to the most specific element going from right to left, IP addresses have the least specific octets on the left and the most specific one on the right. In the interest of maintaining consistency with the DNS namespace, the octets are thus flipped
      - `ping www.example.com`: forward resolution
      - Reverse resolution using `ping`:
        - `ping -a 8.8.8.8`
      - `dig -x 8.8.8.8`: reverse name lookup
        - `dig -x 8.8.8.8 +noall +answer`: makes the `dig` output more precise.
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

- Name registration involves the registration of domains.
- Name registration is how a domain is registered, how its uniqueness is guaranteed, and what are the registration authorities responsible for the name assignment process
- __Domain Name Registration Hierarchy:__
![Domain Name Registration Hierarchy](https://149463845.v2.pressablecdn.com/wp-content/uploads/2017/07/Domain_Industry_Hierarchy-1-768x513.png)

  - A domain represents a public identity on the internet and it is used to identify the IP address of the computer system hosting a web content.
  - To ensure that each domain is unique, name registration has to be processed within a globally distributed framework designed to enforce a certain set of rules; that framework is the domain name registration hierarchy
  - Internet Corporation for Assigned Names and Numbers (ICANN)'s main role is to oversee the huge and complex interconnected network of unique identifiers that allow computers on the internet to find one another.
  - References:
    - <https://www.iana.org/numbers>
    - <https://www.cyberpunk.rs/domain-name-hierarchy-registry-vs-registrar#:~:text=Domain%20registration%20and%20management%20involves,for%20Assigned%20Names%20and%20Numbers).>
    - It is responsible for managing gTLDs and ccTLDs.
    - Managing how root name server systems function
    - Coordinating how IP addresses are supplied to avoid repetition or clashes
    - Maintaining a central repositories of IP addressesEach registry is responsible for obtaining
  - *Registries:*
    - Each registry is responsible for obtaining IP ranges from ICANN in order to allocate them to ISPs across a specific geographic region.
    - e.g. VeriSign
  - *Registrars:*
    - These are ICANN accredited organizations responsible for processing the registration of domain names.
    - e.g. GoDaddy, Namecheap, Bluehost
  - *Resellers:*
    - These are third party companies that offer/sell domain name registration services through registrars
    - e.g. Route53: reseller for two registrars: Amazon Registrar for gTLDs and Gandi for all other TLDs
  - *Registrants:*
    - The people or organizations who register domains through a registrar or a reseller
- __Domain Name registration Process:__
  - The process of a domain name consists of the following steps:
    - The registrant chooses a domain name and submits a request to register it with a register or an ICANN accredited registrar.
    - Provided that the domain name is available, the registrar registers the name and then creates a WHOIS record
      - The WHOIS record contains the registrant's name and contact information, the name and contact information of the registrar, registration date, the name servers, the most recent update and the expiration date
      - The WHOIS record may also provide the adminstrative and technical information of the registrant
    - The registrar will then send you a domain name request along with the contact and technical information of the domain name to the appropriate registry.
    - The registry then files all information provided and it add the domain zone file to the master service, which will tell other servers on the internet where your website is located.
- __Choosing a TLD:__
  - As of June 2020, the entire list consists  of more than 1500 TLDs to choose from, that span at least six distinctive categories and the list keeps expanding
  - The choice of TLD needs to be dictated by the specific use case:
    - Is there support for DNSSEC(DNS Security mechanism that provides protection against certain attacks such as DNS Cache Poisoning)?
      - TLDs such as .aero, .pro, .travel are a few of the TLDs that do not support the security feature.
    - Is there support for internationalized domain names (IDNs)?
      - i.e domain names that include non-ascii characters like with Arabic and Korean languages.
    - Is there support for domain privacy to protect you from people finding your personal information in the registration records?
      - Many ccTLDs such as .us, .eu do not have privacy
    - What is your target audience?
      - If your organization is region specific, such as a health care provider offering services only in Nairobi, using Kenya's ccTLD would make more sense than a gTLD
      - If the org's audience is an even more specific location e.g. Wales, a geoTLD such as .wales would make more sense
    - What is your particular field?
      - If the website is going to advertise your business, you might want to use an industry specific TLD
    - Does the TLD you are interested in have any local presence requirements?
      - Some TLDs like Canada's .ca, China's .cn and US's .us do have local presence requirements, which means that only citizens and entities native to those countries are permitted to register domains within those TLDs
- __Choosing a Second-Level Domain:__
  - Your second-level domain can have any form you like as long as the name you pick follows the rules of the domain name format.
  - Suggestions:
    - __DO's__
      - Use Keywords that reflect your industry
      - Use localized keywords, if applicable. Like the name of the area or city you operate in
      - Try to keep it short; with less than ten characters
      - Ensure it is easy to spell, pronounce, and remember
    - __Do Nots__
      - Try not to use hyphens, numbers or acronyms
  - Check if the chosen domain name is available.
  - Check if it is within your budget
  - Once you have registered your domain, then you own that name space. This means that you will not need to register any subdomains you might create later on.
  - A common strategy is to buy the same domain with multiple TLDs and point them all to a single one
  - Buying mispellings of your domain name is the main way of combating *typosquatting* or *URL hijacking*
  - To check common domain names mispellings: <https://dnstwist.it/>
- __Choosing a Registrar:__
  - Factors to take into consideration when choosing a registrar:
    - Pricing
      - Registrar's registration fee
      - Renewal fee
      - Other potential charges for things like domain transfers
      - Potential cost benefits like bulk pricing options or promotional deals like registering a domain name for several years at a cheaper price
    - Add-on Services
      - Web hosting services
      - Word press hosting
      - Website builders
      - Email hosting
      - Brokerage services
      - Privacy protection
      - SSL protection
      - Customer service support
    - Supported TLDs
    - Policies, such as the registrar's policies on domain transfers, domain expiration...
  - It is recommended that you register your domain name on the registrar but host it on another provider, simply because it is usually easier to switch hosting companies if required later on, provided that the domain name is hosted on a platform different to the one it was registered on.
  - A registered domain that is not associated with a service such as a website is known as a *parked domain*
- __EPP Status Codes:__
  - Reference: <https://www.icann.org/resources/pages/epp-status-codes-2014-06-16-en>
  - Extensible Provisioning Protocol (EPP) domain status codes, also called domain name status codes, indicate the status of a domain name registration.
  - Every domain has at least one status code, if not more.
  - Each EPP code provides useful information about a domain that comes in handy for operations such as:
    - Troubleshooting domain related issues
    - Domain renewals
    - Domain transfers between registrars
  - There are two different types of EPP Status codes; client and server codes
    - Client status codes are set by the registrars and depending on the registrar, they are set upon registering the domain or when requesting it
    - Server status codes are set by the registries and they take precedence over client codes
  - Most common EPP codes:
    - Client codes:
      - *clientHold:*
        - It tells your domain's registry not to activate your domain in the DNS and as a consequence, it will not resolve
        - It is an uncommon status that is usually enacted during legal disputes, non-payment or when your domain is subject to deletion
      - *clientTransferProhibited:*
        - It tells your domain's registry to reject requests to transfer the domain name from your current registrar to another
      - *clientUpdateProhibited:*
        - Tells your domain registry to reject requests to update the domain.
    - Server codes:
      - *ok:*
        - This is the standard status for a domain meaning that it has no pending operations or prohibitions
      - *autoRenewPeriod:*
        - This is a grace period provided after a domain name registration period expires and is extended or renewed automatically by the registry.
        - If a registrar deletes the domain name during this period, the registry provides a credit to the registrar for the cost of renewal.
      - *serverTransferProhibited:*
        - It prevents your domain from being transferred from your current registrar to another
        - It is an uncommon status that is usually enacted during legal or other disputes at your request or when a redemption period status is in place
  - You can check the EPP status code of any domain name you are interested in at <https://lookup.icann.org/en>

## DNS Data Storage

- __Zones and Resource Records:__
  - Name servers store DNS data in a database called a 'zone'.
  - There are two types of zones:
    - Forward lookup zone
      - Typically used for resolving names to IP addresses and it is the zone where most of the DNS data is stored
    - Reverse lookup zone
      - Mainly stores information used for reverse name resolution
  - Each of these zones is a collection of *resource records* (RRs).
    - Just like the records of any database, they are sets of fields organized in rows.
  - There are many types of resource records in DNS and each resource record type contains a specific set of data.
    - e.g. the A record contains a domain name and its associated IPv4 address, while the AAAA record contains the domain name along with its corresponding IPv6 address
  - Despite their differences, all resource record types share a common resource record format which consists of the following parameters:
    - Name
    - Type: Each RR has a different value.
      - .e.g. A record has a type value of 1, while NS record has a type value of 2
    - Class (IN/CH/HS): 99% cases should be `IN` for internet. There is also the Chaos class (CH) and Hesiod Class (HS)
    - TTL (Time to Live): defines the length of time that the resource record remains cached for
    - Resource Data length (RDLength): Indicates the size of the resource data field in bytes
    - Resource Data (RData): The actual data that the resource record stores
- __Common Record Resource Types:__
  - __SOA Record:__
    - Start of Authority (SOA) record indicates the beginning of a zone and it should be the first resource record specified in any zone file
    - There can only be one start of authority record per zone
    - __Format__

    ```SOA format
      <domain name> <TTL> <resource record class> SOA <m-name> <r-name>(
          <serial number>
          <refresh interval>
          <retry interval>
          <expire interval>
          <minimum>
      )
    ```

    - `m-name`: name of the primary authoritative name server for the zone and it is the name server that secondary DNS servers receive updates from in relation to the zone.
    - `r-name`: signifies the email address of the administrator responsible for the zone.
      - Although the value represents an email address, there is no @ sign in it. As far as SOA is concerned, `info.example.com` is the same as `info@example.com`.
    - Serial number: this is the version number of the zone and it is incremented by one every time that a change is made to the zone file.
      - The serial number should never be decreased.
    - The refresh interval, retry interval and expire interval have to do with primary and secondary name service
    - Minimum: The historical purpose of this parameter was to hold the default TTL values for records without an explicit TTL value defined.
      - Nowadays, the minimum parameter represents the TTL value for negative caching.
    - To query an SOA record, we can use either `dig` or `nslookup`:
      - `nslookup -type=soa hostname-or-IPaddress`
        - `nslookup -type=soa example.com`

        ```soa record
        Non-authoritative answer:
        example.com
            origin = ns.icann.org
            mail addr = noc.dns.icann.org
            serial = 2024013028
            refresh = 7200
            retry = 3600
            expire = 1209600
            minimum = 3600
        ```

      - `dig -t soa example.com` or `dig -t soa example.com +short`
        - `-t`: type
      - `dig -t soa example.com +short | tr " " '\n'`

      ``` dig
      ns.icann.org.
      noc.dns.icann.org.
      2024013028
      7200
      3600
      1209600
      3600
      ```

  - __NS Record:__
    - Name Server Record (NS).
    - The NS records point to the authoritative name servers for a zone and it is these name servers that hold the actual DNS information for a domain so that that domain can be accessible to internet users
    - If a domain eg. `example.com` does not have any records configured in its zone, there wouldn't be any references to that domain's name servers, which means that the .com TLD server contacted would not be able to return a list of name servers for `example.com`, which in turn means that nobody would be able to browse that domain.
    - In other words, it is the NS records that ensure the availability of a domain
    - Every zone must have at least 2 NS records, of which each one points to a different name server for redundancy.
      - That way, if one name server goes down or becomes unavailable, DNS queries can go to a different name server.
    - Name servers also reside in topologically separate networks for further resiliency
    - When registering a domain, many DNS as a service providers by default, provision a set of 4 name servers and they would listed as:

    ```name servers
    ns1.example.com
    ns2.example.com
    ns3.example.com
    ns4.example.com
    ```

    - format:
      - `<domain name> <TTL> <class> NS <nameserver's hostname>`
      - domain name. e.g. example.com
      - a TTL value
      - a resource record class (IN, CH, HS)
    - Querying ns record:
      - `nslookup -type=ns <hostname or IP address>`
        - `nslookup -type=ns example.com`

        ```nslookup ns
        Non-authoritative answer:
        example.com     nameserver = b.iana-servers.net.
        example.com     nameserver = a.iana-servers.net.

        Authoritative answers can be found from:
        a.iana-servers.net      internet address = 199.43.135.53
        b.iana-servers.net      internet address = 199.43.133.53
        a.iana-servers.net      has AAAA address 2001:500:8f::53
        b.iana-servers.net      has AAAA address 2001:500:8d::53
        ```

      - `dig -t ns example.com`

  - __A & AAAA records:__
    - The resource record that stores the association between a domain name and an IPv4 address is the address or A record
      - The A record contains a mapping between a domain name and an IPv4 address
      - The AAAA or quad-A record contains a mapping between a domain name and an IPv6 address
        - The reason why it is represented by 4 A's is to signify that the value stored in it is four times as big as the one stored in the A record, considering that an IPv4 address has 32 bits and an IPv6 address has 128 bits
      - It is possible for an A record and AAAA record to point to the same domain in cases where dual stack is required
    - The A record is the primary record in DNS and it is queried in forward lookup requests
    - Format:
      - `<domain name> <TTL> <class> A <IPv4 address>`
        - ns1.example.com. IN A 192.168.1.35
      - `<domain name> <TTL> <class> AAAA <IPv6 address>`
        - ns1.example.com. IN AAAA 2001:354:8::22
    - Querying an A/AAAA records:
      - `nslookup -type=a <hostname or IP address>`
        - `nslookup -type=a example.com`

        ```a record
        Non-authoritative answer:
        Name:   example.com
        Address: 93.184.216.34
        ```

      - `dig -t -a example.com` or `dig -t a example.com +short +answer`

        ```a record
        ;; global options: +cmd
        ;; Got answer:
        ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1888
        ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

        ;; OPT PSEUDOSECTION:
        ; EDNS: version: 0, flags:; udp: 4096
        ;; QUESTION SECTION:
        ;example.com.                   IN      A

        ;; ANSWER SECTION:
        example.com.            51339   IN      A       93.184.216.34

        ;; Query time: 17 msec
        ;; SERVER: 2600:1700:1bd0:3e20::1#53(2600:1700:1bd0:3e20::1)
        ;; WHEN: Tue Mar 19 14:54:35 CDT 2024
        ;; MSG SIZE  rcvd: 56
        ```

      - `nslookup -type=aaaa <hostname or IP address>`
        - `nslookup -type=aaaa example.com`

        ```aaaa record
        Non-authoritative answer:
        example.com     has AAAA address 2606:2800:220:1:248:1893:25c8:1946
        ```

      - `dig -t -aaaa example.com` or `dig -t aaaa example.com +short +answer`

      ```aaaa record
      ; <<>> DiG 9.10.6 <<>> -t aaaa example.com
      ;; global options: +cmd
      ;; Got answer:
      ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26708
      ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

      ;; OPT PSEUDOSECTION:
      ; EDNS: version: 0, flags:; udp: 4096
      ;; QUESTION SECTION:
      ;example.com.                   IN      AAAA

      ;; ANSWER SECTION:
      example.com.            39519   IN      AAAA    2606:2800:220:1:248:1893:25c8:1946

      ;; Query time: 17 msec
      ;; SERVER: 2600:1700:1bd0:3e20::1#53(2600:1700:1bd0:3e20::1)
      ;; WHEN: Tue Mar 19 14:53:47 CDT 2024
      ;; MSG SIZE  rcvd: 68
      ```

  - __PTR record:__
    - Pointer Record (PTR)
    - The PTR record is the opposite of A or AAAA records. The PTR record is queried in reverse name resolution
    - The name space for IPv4 addresses is the .in-addr.arpa.domain and the name space for IPv6 addresses is the .ip6.arpa domain.
    - Format:
      - `<reverse domain name> <class> PTR <domain name>`
      - Assuming the IPv4 address is `207.17.120.8`, the PTR record would be `8.120.17.207.IN-ADDR.ARPA`

      - IPv6
        - `a.9.8.7.6.5.e.f.f.f.4.3.2.1.0.0.0.0.0.0.0.0.f.0.b.d.0.1.0.0.2.IP6.ARPA` assuming the IPv6 address is `2001:0db8:0f00:0000:0012:34ff:fe56:789a`
    - Pointer records are placed in the reverse lookup zone
    - Querying PTR:
      - `nslookup -type=ptr 10.1.1.80`
        - `nslookup -type=ptr 2600::`

      - `nslookup 10.1.1.80`
        - `nslookup 2600::`

      - `dig -x 10.1.1.80` or `dig -x 10.1.1.80 +short +answer`
        - `dig -x 2600:: +short +answer`

  - __CNAME Record:__
    - CNAME stands for Canonical Name, which is a real name of an object referenced by an alias.
    - In other words, this record maps one domain name to another
    - Format:
      - `<alias> <class> CNAME <TTL> <canonical name>`
      - alias e.g. `www.example.com`
      - canonical name: `example.com` (the real name that the alias is pointing to)
    - Querying a CNAME:
      - `nslookup -type=cname ns1.mydomain.com`
      - `dig -t CNAME ns1.mydomain.com`
    - Use Cases:
      - CNAME records can be used to map subdomains to apex domain such as `www.example.com` to `example.com.`.
        - This way, if the IP address if the host changes, only the DNS A record of the apex domain needs to be updated and all the CNAME recods will follow along with whatever changes are made to the parent domain so CNAME records make it easy to run multiple services from one IP address.
      - Redirect multiple TLDs to the same second-level domain.
        - e.g `mydomain.com.au` and `mydomain.co.nz`can be directed to `mydomain.com`
      - Used to validate ownership or control of a domain
    - Restrictions:
      - A CNAME record must always point to another domain name and never directly to an IP address
      - A CNAME record cannot point to an NS or MX record
      - A CNAME record cannot coexist with another record for the same name.
        - For example, it is not possible to have both a CNAME and a TXT record for `www.example.com.`
    - Best Practice:
      - A CNAME can point to another CNAME, a mechanism known as *CNAME chaining*. It is considered best practice NOT to use CNAME chaining.
        - This is because it requires multiple DNS lookups before the intended domain can be loaded, which slows down the name resolution process and in turn impacts user experience
        - It is better therefore to point CNAME to a canonical name.

  - __TXT Record:__
    - Text Record (TXT)
    - It associates textual information with an FQDN
    - Format:
      - `<domain name> <class> TXT <TTL> <textual data>`
    - Although the official format for storing data in a TXT record theoretically involves using attribute value pairs (such as `"attribute=value"`) delimited by an equals sign and enclosed by quotation marks, domain admins can use their own formats when configuring TXT records; which is a testament to the flexibility of the TXT record
      - The data can be placed inside its value could be any text that the admin wants to associate with their domain.
    - TXT records were originally created to associate a domain with textual information(human-readable notes), but they are currently used for domain ownership and email security purposes.
      - The value of a TXT record can have human-readable notes as well as machine-readable data
    - The same domain can be associated to multiple TXT records
    - Querying TXT records:
      - `nslookup -type=txt example.com`
      - `dig -t txt example.com`
    - Use cases:
      - Associating domains with textual data
      - Proving domain ownership
      - Strengthening email security

  - __MX record:__
    - Mail Exchange Record (MX)
    - An MX record maps a domain name to an email server
    - Email has always been heavily reliant on DNS, perhaps more so than any other TCP/IP based application, and MX records provide the necessary infrastructure for it to work
    - Format:
      - `<domain name> <class> MX <TTL> <preference-value> <email-server>`
      - Why does email-server not feature an `@` symbol?
        - When email clients send an email to any recipient, they use the `@` sign as a means to separate the mail server from the domain it is meant to receive the emails for, e.g. `support@example.com`.
        - As far as name servers are concerned, the names of mail servers inside the mx records are configured with `.` not `@`
      - `preference-value`: it allows a DNS administrator to specify multiple email service so that if the first server is down, the emails will be forwarded to the backup email server, thus achieving redundancy
        - The lower the preference value of the mail server, the higher the priority of that server will be
        - It is also possible to specify multiple backup email servers:

          ```mx record
          <domain name> <class> MX <TTL> 10 primaryemail.www.example.com
                                         20 seconadryemail.www.example.com
                                         30 backupemail.www.example.com
                                         40 backupemail2.www.example.com
          ```

    - How can the authoritative name server know of the email server's location, Should there not be an additional record that in turn maps the hostname of that server to an IP address?
      - Yes. An A record needs to be defined alongside the MX record so that the name server can forward email to the correct endpoint.
      - Additionally, A records would typically be created for as many email servers the domain is associated with

      ```mapping A record
      <domain name> <TTL> <class> A <IPv4 address>
      ```

    - An MX record must always point to another domain and never to a CNAME record
    - Querying an MX record:
      - `nslookup -type=mx google.com`
      - `dig -t MX google.com`

## DNS Protocol Analysis

- __DNS Messages:__
  - The core function of name resolution is carried out by two different messages:
    - Query: sent by the client
    - Response: sent by the server
  - Each exchange of these messages is referred to as *transaction* and it is assigned a transaction ID by DNS
  - If a client sends three different name requests to three different servers, the transaction ID makes it easy to find which query elicited which response
    - This can be a helpful feature that can be used when troubleshooting DNS issues or when conducting a forensic network analysis
  - As a layer 7 application, DNS has to rely on a transport protocol at layer 4 to transfer DNS messages from client to server and vice versa
  - Most network protocols residing at the application layer usually rely on either TCP or UDP. However, DNS uses both TCP and UDP depending on the operation taking place
    - For name resolution where speed is of the essence, UDP is used as a transport protocol to carry both requests and responses
      - Since UDP does not offer a reliable method of delivering messages, it is up to the client to keep track of the requests sent, so that if a response is not received at specific time interval, the corresponding request can be retransmitted
      - In the interest of preventing excessive DNS traffic on the network, retransmissions are usually sent at an interval ranging from 2-5 seconds
      - All UDP DNS messages are limited to a payload of 512 bytes
      - If a response message is larger than that, the message is truncated and a special bit in the header is said to indicate this outcome. In such an event, the client would then be expected to retry the query over TCP instead, which doesn't have the same size limitation as UDP.
    - TCP is used when data has to be delivered reliably, as in the case in scenarios such as zone transfers or when a DNS response requires more than 512 bytes of space
      - Transactions taking place over TCP remain a small fraction of overall DNS traffic, regardless of which transport protocol is used
  - Regardless of the transport protocol used, the standard port that the server listens to by default is port 53, while the port used by the client is always an ephemeral one
  - Other types of DNS messages outside the area of name resolution are:
    - Notify: Allows master servers to inform worker servers when the zone has changed, carried over UDP.
    - Update: Used to add or delete resource records or resource record sets from a specified zone and it can be carried over either UDP or TCP depending on the size of the request.

- __RCODES:__
  - Response Codes (RCODES)
  - RCODES indicate whether an error condition exists in the response and each RCODES corresponds to a numeric value.
  - Every response message contains an RCODES and every RCODES with a value other than 0 suggests an error;
  - Full list of RCODES: <http://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-6>
  - The `NOERROR` RCODE is the only response code that indicates success
  - `dig amazon.com`

  ```RCODES
    ; <<>> DiG 9.10.6 <<>> amazon.com
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39106
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;amazon.com.                    IN      A

    ;; ANSWER SECTION:
    amazon.com.             739     IN      A       52.94.236.248
    amazon.com.             739     IN      A       54.239.28.85
    amazon.com.             739     IN      A       205.251.242.103

    ;; Query time: 14 msec
    ;; SERVER: 2600:1700:1bd0:3e20::1#53(2600:1700:1bd0:3e20::1)
    ;; WHEN: Wed Mar 20 15:21:26 CDT 2024
    ;; MSG SIZE  rcvd: 87
  ```

  - Common RCODES:
    - 0, NoError, No Error: Success
    - 1, FormErr, Format, Error: the name server is unable to interpret the query
    - 2, ServFail, Server Failure: the name server was unable to process this query due to a problem with the name server
    - 3, NXDomain, Non-Existent Domain: The domain name reference in the query does not exist
    - 4, NotImp, Not Implemented: The name server does not support the requested kind of query
    - 5, Refused, Query Refused: The query was refused due to the fact the the name server refused to perform the specified operation for policy reasons

- __The DNS Header:__
  - The DNS OpCodes are assigned as follows:
  - |OpCode   | Name                                |
    |---------|-------------------------------------|
    | 0       | Query                               |
    | 1       | IQuery (Inverse Query)- Obsolete    |
    | 2       | Status (Obsolete)                   |
    | 3       | Unassigned                          |
    | 4       | Notify                              |
    | 5       | Update                              |
    | 6-15    | Unassigned                          |

  - The DNS header consists of a series of fields:
    - Transaction ID: Associates DNS queries with their corresponding responses
    - QR : indicates whether the header us for a query, represented by a 0, or for a response, represented by 1
    - OP (Operation) Codes: specify the query type. Each DNS OpCode is assigned a name.
    - AA: Authoritative Answer and it is valid in responses. The AA specifies the responding name server is an authority for the domain name being requested
    - TC: Truncation. Set when a message is truncated due to its length being greater than the maximum size; 512 bytes
    - RD: Recursion Desired. It is set in the query upon the client sending a recursive request to the DNS resolver
    - RA: Recursion Available. Denotes whether the name server responding supports recursive queries
    - Z: reserved for future use and it must be zero in all queries and responses
    - AD: Authentic Data
    - CD: Checking Disabled
      - Both AD and CS are important in the DNSSEC mechanism
    - RCODE: Indicate whether an error condition exists in the response
  - QDCOUNT/ZOCOUNT: Unsigned Integer Field count that represents the number of questions
  - ANCOUNT/PRCOUNT: Answer count field that represents the number of answers and
  - NSCOUNT/UPCOUNT: represents the number of authority resource records
  - ARCOUNT: represents the number of additional records

- __Capturing and Analysing DNS traffic:__
  - There are two main methods of capturing network traffic:
    - Passive traffic capture: You can do this by running `tcpdump` on the network interfaces to cache only server active traffic capture
    - Active traffic capture: This is needed when there is no direct access to the computer systems involved or the network path you wish to capture, and so to intercept it, you would need to implement a more active technique such as placing a proxy or a network tap in the middle of the tap.
  - Capture point: the precise location where to set up the traffic listener
  - Always try to determine the best capture point wisely

- __Constructing DNS Packets:__
  - Scapy is a powerful packet manipulation program which is capable of forging packets from scratch, ..etc.
  - Each Packet in Scapy needs to Follow the structure of the TCP/IP model starting with the network layer, followed by the Transport layer, etc.
  - Installing Scapy:
    - `sudo apt-get update -y`
    - `sudo apt-get install python3-pip`
    - `sudo python3 -m pip install --pre scapy[complete]`
    - `sudo scapy`

## DNS Troubleshooting

- __Troubleshooting Methodology:__
  - DNS problems can be classified into two broad categories:
    - Configuration issues: refer to problems arising when setting up the DNS infrastructure for the first time and they are more related to projects than support work
      - As such, they have a relatively low priority but we still need to resolve them in a timely fashion
      - Troubleshooting:
        - Do the properties of your system match the ones outlined in the guide (i.e OS, version, system, requirements, etc.)?
        - Have the same resources been allocated to your machine?
        - Have the reference software packages been installed successfully?
        - Have you put in place any additional configuration or changed any other settings?
        - Have any of the configuration steps you were instructed to take been skipped?
        - Have any errors been encountered along the process?
        - What do the packets tell you?
        - What do the logs say?
    - Break-and-Fix issues: These are incidents that can suddenly occur with an immediate negative impact on our environment
      - These issues imply that the DNS setup had been working as expected for a certain period of time until something happened that disrupted the service
      - The productivity of the end users will be affected
      - It is a level-1 priority
      - Troubleshooting:
        - Define the problem
        - Define the scope of the problem (who, what, when, how)
        - Breakdown your infrastructure into distinctive logical areas
        - Create a list of suspect components to check for each section of your environment
        - Review each component in one section before moving on to the next one. Always start with the easiest components
        - Use the Corson Technique <https://collegeinfogeek.com/corson-technique/>
        - If all else fails, escalate
      - Annotating your findings as you are troubleshooting break-and-fix issues is crucial

## Troubleshooting DNS Latency Issues

- Typical causes for DNS latency:
  - High resource utilization on the DNS server
  - Problems related to the DNS software, e.g. Bind9
  - Bandwidth saturation on the DNS server
  - Network related issues
- Wireshark is one of the best tools to use when troubleshooting DNS latency
- The DNS time field only resides in DNS response messages only

## DNS Security

- __DNS Cache Poisoning Attack:__
  - DNS cache poisoning or DNS spoofing
  - By poisoning the cache of the DNS resolver, the attacker can redirect the end user to a fraudulent website.
    - The purpose of the DNS cache poisoning attack is to abuse the way DNS caches work by poisoning the resolver's cache so that name lookups originated from a client are answered by a malicious actor who redirects the end user to a fraudulent web page
    - That website is typically a mirror image of a legitimate site so that once the end users are redirected there, they are tricked into a specific set of actions engineered by the attacker
    - Some actions involve:
      - Presenting authentication prompts encouraging the victim to supply their credentials
      - Luring the user into downloading files infected with malware
    - Impact:
      - Stolen credentials
      - Data theft
      - Critical data encrypted with ransomware
      - Compromised hosts that become bots as part of a botnet
  - Threat Vectors:
    - *Man in the Middle Attack:* The attacker places themselves between the client and the server
      - By using tools such as Arpspoof, it can modify the Mac addresses in the DNS resolver's ARP table, causing it to think that the attacker's computer belongs to the client. The client is also tricked into thinking that the system controlled by the attacker is the DNS server
      - As such, the attacker can use tools such as DNS spoof to direct all DNS requests to the fake sites designed by the attacker
    - *DNS Server Hijacking:* This entails compromising the DNS resolver directly with a goal of injecting false data into its cache to achieve DNS spoofing and redirect the client to the attacker's site
    - *Client Machine Hijacking:* This involves compromising the client directly
      - Once the attacker has gained access to the client, they can proceed with injecting false DNS data in the hosts file, which is consulted by the OS before DNS kicks in
      - The attacker can then accomplish DNS spoofing without touching the DNS resolver, since name requests originated by the compromised client will never make it there.
    - *Birthday Attack:* Most sophisticated DNS cache poisoning vector
      - The attacker tries to guess the transaction ID of the client's DNS requests so that they can respond to it with a false response of their own, this poisoning the DNS resolver's cache, which in turn then serves the attacker's IP address
  - Mitigation Measures:
    - DNSSEC: Domain Name Security Extensions
      - It is a means of verifying DNS data integrity and origin
      - It uses public key cryptography to verify and authenticate data thus preventing forgery
      - Downside:
        - When the DNS resolver needs to verify the signature with the authoritative DNS server, the name resolution process slows down, which is why it is not widely adopted
    - DNS over HTTPS (DoH)
    - DNS over TLS (DoT)
      - These standards (DoH and DoT) are designed to keep DNS requests secure without sacrificing speed like DNSSEC
      - Unlike DNSSEC which verified the identity of the DNS root servers and authoritative name server in communication with DNS resolvers, DoH and DoT encrypt DNS traffic, making it harder for attackers to tamper with DNS requests and responses while in transit
      - Difference between DoH and DoT:
        - DoH uses port 443
        - DoT used port 853
    - Patching DNS software:
      - For example, if you have configured your resolver with Bind, make sure that you are using the latest version of Bind so as to keep up to date with the latest security patches
    - Harden the client systems by applying appropriate endpoint security in order to reduce the attack surface to prevent client machine hijacking attacks
  - Encrypting the DNS traffic, patching all DNS-related software and enforcing endpoint security are some of the strongest mitigation measures

- __NXDOMAIN Attack:__
  - NXDOMAIN is a DNS-based Denial of Service (DoS) type of attack since it impacts the availability of the DNS service by flooding it with requests for invalid or non-existent records
  - The attacker can generate and transmit large volumes of unique, fake subdomains for each request sent to the DNS resolver. This is known as *random subdomain attack*
  - The DNS resolvers continues attempts to resolve the fake domains in the attacker's name lookup requests which leads to high resource utilization on the DNS resolver itself, which makes it difficult to respond to legitimate requests
  - On top of that, since the records queried by the attacker do not exist, the DNS resolver cache is filled up with NxDomain replies, slowing down the server's response time for legitimate requests
  - The NXDOMAIN attack takes advantage of negative caching.
  - When the cache gets filled up with nxdomain responses, valid cache entries get pushed out resulting in further service degradation
  - The fake subdomains are typically prepended to a legitimate apex domain such as example.com
  - Consequently, the same domain attack can also cause performance degradation on the authoritative name servers, which try to resolve the malicious name queries received
  - For a script to imitate an nxdomain attack:
    - `git clone <https://github.com/nuck22d/nxdomain_attack.git>`
    - `cd nxdomain_attack`
    - `chmod u+x ndomain_attack.sh`
    - `./nxdomain_attack.sh`
  - Mitigation Measures:
    - Restrict DNS queries to trusted clients only
    - Block the offending source IP addresses
    - Flush the cache on the DNS resolver
    - Use dedicated solutions by specialized vendors

- __DNS Query Flood Attack:__
  - The DNS query flood attack is another DoS attack that aims at disrupting the availability of a DNS server by flooding it with name requests
  - Unlike the domain attack which involves queries against non-existent records,the DNS query flood attack entails the transmission of legitimate requests but at an extremely high volume
  - If successful, the targeted name servers slows down or becomes totally unresponsive to legitimate requests due to high resource utilization
  - It is a 'direct' DoS attack, which is different from the DNS Amplification Attack which is a 'reflective' DoS attack
  - By design, `dnsperf` is a DNS performance testing tool
  - Building dnsperf:
    - `git clone https://github.com/DNS-OARC/dnsperf.git`
    - `cd dnsperf`
    - `.autogen.sh`
    - `./configure`
    - `make`
    - `make install`
  - Mitigation Measures:
    - Restrict DNS queries to trusted clients
    - Block the offending source IP addresses
    - Rate limiting
    - Deploy a cache only DNS server in front of of the authoritative name server if possible, so that the cache-only server can serve cached queries that do not get forwarded all the way to the name server
    - Overprovision bandwidth on the name server itself so that it can handle a greater amount of requests

- __Phantom Domain Attack:__
  - In a phantom domain attack the attacker uses real domains they have set up whose name servers have been configured to either respond very slowly to requests or not respond at all
  - The phantom domain attack is another type of DNS-based DoS attack
    - The attacker lays the groundwork by first configuring several domains
    - Then they configure the authoritative name servers of those domains to either respond to requests very slowly or not at all
    - They then proceed to send a huge number of queries to the victim's DNS resolver, which has to spend time and resources doing the recursion against the records of the phantom domains whose name servers will simply not respond
  - Mitigation Measures:
    - Rate limiting
    - Restricting requests queries per server and per zone
    - Using dedicated solutions by specialized vendors.
      - For example, F5's Big-ip is designed to time out the connection and release the requests in the queue so that the resolver does not need to wait for responses that will never come

## References

- <https://en.wikipedia.org/wiki/Top-level_domain>
