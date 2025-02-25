### Welcome to the Danish SMART App Launch Specification

This is the Danish implementation guide for the SMART App Launch mechanism.

{% include cross-version-analysis-inline.xhtml %}

It builds on top of both the HL7 [SMART App Launch](https://hl7.org/fhir/smart-app-launch/) and the HL7 [International Patient Access](https://build.fhir.org/ig/HL7/fhir-ipa/) specifications.

{% include dependency-table-short.xhtml %}

SMART App Launch is the mechanism through which third-party apps can be integrated with Electronic Health Record (EHR) systems. It specifies how apps gain knowledge of which practitioner or patient wants to access which patient's information, and how the app obtains the access token that can then be used to access further information.

You can think of it as a single-sign-on (SSO) mechanism, but it is actually a bit more and extends to communicating the context too.

When launched, the third party apps can either stand on their own or be embedded into the views of the EHR or a patient portal.

The SMART specification is suitable for both web based apps and native apps. It makes a distinction between [public and confidential apps](https://hl7.org/fhir/smart-app-launch/app-launch.html#support-for-public-and-confidential-apps).

In addition to launching apps, the main SMART specification defines a [profile for backend services](https://hl7.org/fhir/smart-app-launch/backend-services.html).

### Companion Specifications

There is a separate implementation guide for [Danish Core Profiles](https://hl7.dk/fhir/core/) that defines the Danish Core profiles for some of the key FHIR resources.

### Why Do We Need to Profile the SMART Specification?

The [SMART](https://www.hl7.org/fhir/smart-app-launch/) App Launch specification is already a globally applicable specification. The
[International Patient Access (IPA) specification ](https://hl7.org/fhir/uv/ipa/) adds some more constraints and details to it. Do we
really need something more?

We have found out that there are still some places in both of these specifications that allow some implementation freedom but may be tricky for app developers to support. In this implementation guide, we aim to provide clarity on topics like how an app best learns the organization or organization unit the practitioner launching the app works for (when launching the app).

We believe we can get some of these details sorted out more efficiently in the local Danish context. We still aim to feed our learnings and developments with the wider [SMART](https://www.hl7.org/fhir/smart-app-launch/) community and help get parts of them adopted to the SMART and [IPA](https://hl7.org/fhir/uv/ipa/) specifications.

### I still don't follow - why do we need this?
Okay, a simplified take on it is like this:

 * We have [DK Core](https://hl7.dk/fhir/core). That defines the FHIR models in a danish perspective
 * We have [SMART](https://www.hl7.org/fhir/smart-app-launch/) that defines a standardized login flow to a system (for obtaining access to patient data from e.g. either a clinician or a patient from an app or another clinical system)
 * We have [IPA](https://hl7.org/fhir/uv/ipa/) which is bare minimum profiling on top of the regular FHIR model + the added use of [SMART](https://www.hl7.org/fhir/smart-app-launch/)
 * We have support of the *[IPA](https://hl7.org/fhir/uv/ipa/) model parts* in [DK Core](https://hl7.dk/fhir/core) (from v3.4.0) but deliberately not the [SMART](https://www.hl7.org/fhir/smart-app-launch/) parts in [DK Core](https://hl7.dk/fhir/core).
 * **We now have DK SMART** (this IG) to frame how SMART can be used in Denmark. Its mostly guidelines as [SMART](https://www.hl7.org/fhir/smart-app-launch/) is pretty well-defined in itself
 
So, when we pair [DK Core](https://hl7.dk/fhir/core) (with the danish models) and DK SMART (which outlines standardized access) we end up with a standardized way of expressing the data model and the data access which is the core essence of bridging systems and break down silos. This inherently supports initiatives like [https://medcom.dk/projekter/apps-i-almen-praksis/](https://medcom.dk/projekter/apps-i-almen-praksis/) and boards like [https://laegemiddelstyrelsen.dk/da/udstyr/naevnet-for-sundhedsapps/](https://laegemiddelstyrelsen.dk/da/udstyr/naevnet-for-sundhedsapps/)

### What about existing national login solutions?
National existing solutions like [MitID](https://www.mitid.dk/) and [SEB](https://services.nsi.dk/seb) as well as any local [SAML-based](https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language) solution can be incorporated into using [SMART](https://www.hl7.org/fhir/smart-app-launch/)-flows for the authentication/authorization-parts adding value to the entire chain. The use of [SMART](https://www.hl7.org/fhir/smart-app-launch/) does not compromise that. It only strengthens is.

### Notable SMART Implementations in other Nordic countries

See the Finnish progress [here](https://hl7.fi/fhir/finnish-smart/#notable-smart-implementations-in-finland)

To learn about the current status in Denmark, please contact [HL7 Denmark](https://www.hl7.dk/). We're happy to give you an overview.

### Profiling Approach
The base FHIR specification works on a global scope. It is hard to achieve consensus on many things globally. However, smaller regions and jurisdictions are in a better position to agree on tighter constraints. We take benefit of this and move faster with things that we can agree on on a local level.

We are also committed to sharing our learnings with the wider FHIR community and get parts of the definitions adopted in the international main specifications.

We hope that publishing examples gives new implementers a glance of how systems exchange information. However, implementers are **strongly encouraged** to read the main SMART specification and the relevant parts of the [IPA](https://hl7.org/fhir/uv/ipa/) specification. This implementation guide should not be used as a comprehensive specification on which to build implementations.

### Governance

The profiling work is performed in a project driven by [HL7 Denmark](https://www.hl7.dk).
See the
[announcement](https://confluence.hl7.org/display/HD/DK+IPA+SIG) and the
[running european memo](https://docs.google.com/document/d/1K0_0gDacXwYJxYd3vnI9IvD4ug2JssALiOAln14hZGo/edit?usp=sharing). We warmly welcome new participants to the project.

The team involved in creating the first version of the implementation guide includes
* Jens Kristian Villadsen, Trifork
* Christian Gasser, Lakeside
* Ole Vilstrup, MedCom
* Michael Johansen, MedCom
* Asger Halkier, Sundhedsdatastyrelsen
* ... and others

Each published major version of this implementation guide goes through the ballot and voting processes of HL7 Denmark.

### Danish Specific Considerations
The following sub sections will list recommendations when using SMART in a Danish setting

#### Client authentication
It is discouraged to use symmetric authentication (client_secret) for clients that cannot maintain a secret as listed [here](https://hl7.org/fhir/smart-app-launch/client-confidential-symmetric.html) and hence should be avoided.

#### MinLog
Any vendor providing access to data (not limited to, but including using [SMART](https://www.hl7.org/fhir/smart-app-launch/)) MUST remember that access to such provided data in many cases are subject to be sent to [MinLog](https://www.nspop.dk/display/public/web/MinLog2+-+Min+Log+Registrering). 


### Collaboration

We want this implementation guide to be useful for you.

If you are implementing SMART App launch in a system or application that is meant to be used in Denmark and are thinking of some implementation details, you are probably in the right place and this implementation guide should help you with those questions. If this implementation guide in any way fails to give you the answers you are looking for, we'd love to hear about it so we can make it better. Please do be in touch in one of the ways listed below.

#### Open an Issue in GitHub

The source code of this implementation guide is maintained in a [publicly accessible repository](https://github.com/hl7dk/dk-smart) in GitHub. Issues opened in that GitHub repo are very welcome. They help the team pick up any proposed changes or additions and to discuss them publicly.

#### Open a Pull Request in GitHub

Pull requests are even better. If you are in a position to suggest how exactly your proposal should be implemented in the specification, do it! It helps the team maintaining the implementation guide a great deal.

#### Participate in IG Development and Maintenance

Please also consider joining the development effort. This is the best way to affect the outcome of the profiling work. You may even be compensated for your efforts. Please be in touch with HL7 Denmark to discuss options, if this even remotely interesting for you.

The best implementation guide is the one that reflects the views and the consensus of the whole FHIR community!

### Safety Considerations
This implementation guide defines data elements, resources, formats, and methods for exchanging healthcare data between different participants in the healthcare process. As such, clinical safety is a key concern. Additional guidance regarding safety for the specification’s many and various implementations is available at [https://www.hl7.org/FHIR/safety.html](https://www.hl7.org/FHIR/safety.html).

Although the present specification does give users the opportunity to observe data protection and data security regulations, its use does not guarantee compliance with these regulations. Effective compliance must be ensured by appropriate measures during implementation projects and in daily operations. The corresponding implementation measures are explained in the standard. In addition, the present specification can only influence compliance with the security regulations in the technical area of standardisation. It cannot influence organisational and contractual matters.

### License and Legal Terms 

This document is licensed under Creative Commons [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) Public Domain Dedication.

This implementation guide contains and references intellectual property owned by third parties ("Third Party IP"). Acceptance of these License Terms does not grant any rights with respect to Third Party IP. The licensee alone is responsible for identifying and obtaining any necessary licenses or authorizations to utilize Third Party IP in connection with the specification or otherwise.

HL7&reg;, HEALTH LEVEL SEVEN&reg;, FHIR&reg; and the FHIR <img src="icon-fhir-16.png" alt="logo" style="float: none; margin: 0px; padding: 0px; vertical-align: bottom"/>&reg; are trademarks owned by Health Level Seven International, registered with the United States Patent and Trademark Office.

See also [http://hl7.org/fhir/license.html](http://hl7.org/fhir/license.html).

#### Other Intellectual Property Statements

{% include ip-statements.xhtml %}
