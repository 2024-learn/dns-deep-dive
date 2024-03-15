# DNS Deep Dive

- __What is DNS?__
- DNS stands for Domain Name System
- The core function of DNS is to map symbolic human-readable names to IP addresses (name resolution)

## DNS Functions
  
A. __Name Space:__

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
    - *Fully Qualified Domain Name(FQDN):* the absolute reference to a domain name. e.g <www.example.com.>
    - NOTE: FQDN is not the same thing as a URL, as a URL contains the domain name of a site as well as other information, including the transfer protocol and the path. e.g. <https://www.example.com/learning/>
    - A portion of a domain name such as the host portion of the <www.example.com> domain is known as a *Partially Qualified Domain Name(PQDN)*
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

B. __Name Resolution:__

- The action of converting a domain name into an IP address is referred to as name resolution
- Local name resolution occurs locally on the end user's machine without contacting any external servers or systems of any kind
  - In this type of resolution, there are no root servers, TLD servers, or any similar infra.
  - Local name resolution is controlled by the host table, a simple text fil cinsisting of static mappings between IP addresses and host names.
    - The host table is actually a predecessor of DNS, and it was one of the earliest named systems ever created in computing
  - The host table is represented by the host file: `/etc/hosts`
  - The host table is read before DNS is used
  - Admin priviledges are required to modify the hosts file
  - Local name resolutiom is also known as host table name resolution
  -

C. __Name Registration:__

- name registration is how a domain is registered, how its uniqueness is guaranteed, and what are the registration authorities responsible for the name assignment process

  -
  -
