---
layout: post
title: "Can you avoid cloud vendor lock-in?"
date: 2011-10-13 00:00
comments: true
published: true
categories: cloud lock-in fungibility
---
{% img right http://dl.dropbox.com/u/2093887/blog/pictures/cloud-lockin.jpg 200 200 %}

Vendor lock-in is the situation in which you are dependent on a single vendor for a product (i.e., a good or a service) and cannot move to another vendor without substantial costs and/or inconvenience. Lock-in is typically a result of standards controlled by the vendor, thereby granting the vendor some degree of monopoly power that usually leads to better profits for such vendor.

Here is a recent example illustrating the lock-in problem: 

Few weeks ago, Google announced a significant [price increase](http://code.google.com/appengine/kb/postpreviewpricing.html) for use of its Google App Engine Platform-as-a-Service (PaaS). Google App Engine users knew and expected that Google would increase the price at some point but what shocked most developers was the jump in price which increased the cost of using the Google App Engine runtime environment by 100% or more in specific cases. It is a non trivial exercise to port to another location once an app is deployed on the Google App Engine infrastructure.
{% pullquote %}
This led to a big backlash on the App Engine google groups. Google responded with a few adjustments to its pricing but this incidence resurfaced some doubts about the cloud. Hart Singh of flipbook LLC, creators of the flipbook app on Facebook, raised a concern, "{"My team spent so much time learning app engine but I continue to wonder if we are betting our company on Google...any app we build can only be run on the Google App Engine."}"
Google App Engine requires custom code to run apps in that environment. Customizing take effort and time and impacts the bottomline. 
{% endpullquote %}

<!--more-->

According to Gartner, cloud computing customers are more concerned about vendor lock-in than about cloud security. So what exactly lock-in means in the context of cloud computing. For this we look at the various types of lock-in:

**Horizontal lock-in** limits the ability to replace a product with a comparable competing product. If you chose CRM solution from Oracle earlier, then you will need to migrate your data and code, retrain your users and rebuild the integrations to your other solutions if you want to move to Microsoft Dynamics CRM. Wouldn't it be nice it you could reuse your garage, cabling, etc., when you switch from Toyota Prius to a Nissa Leaf? The higher you go up the levels of the cloud computing stack the stronger is the horizontal lock-in.

Moving from one SaaS solution to another in the cloud is no differenf from moving from one software to another provided there is a clear migration path. But PaaS can be a very deep lock-in especially if code needs to written to comply with PaaS requirement. IaaS lock-in is much less severe however the underlying hypervisors (_containers of virtual machines_) differ and can lead to some complexity during migration from one IaaS vendor to another.

**Vertical lock-in** limits choice in other levels of the cloud services stack. For example, selecting solution A mandates the use of database B, operating system C, hardware vendor D and/or implementation partner E.  Open standards help prevent vertical lock-in by ensuring that hardware, middleware, and operating systems could be chosen independently.  

Vertical lock-in built-into SaaS and PaaS offerings as the underlying infrastructure comes with the service. However, you won't need to worry about managing the underlying layers of the cloud stack. IaaS offers comparatively less vertical lock-in. You know that application logic and data need proximity to gain decent performance so you should almost always procure storage services from the same IaaS provider as used for application logic processing. 

**Inclined lock-in** is a tendency to buy as many solutions as possible from one provider, even if such solutions in some of these areas are less desirable. You tend to sometimes select a single vendor not only to make management, training and integration easier with a single throat to choke but also to be able to demand higher discounts. This leads to large and powerful vendors causing a high degree of inclined lock-in. 

**Generational lock-in** becomes an issue when an entirely new generation of technology reaches the market. No technology generation and no platform lives forever. The first three types of lock-in are not too bad if you picked the right solution vendors (generally the ones that turn out to become the market leaders). But even such market leaders at some point reach end of life. You want to be able to replace them with the new generation of technology without it being prohibitively expensive or even impossible.

**Vendor lock-in makes you vulnerable. Think defensively before committing**

With vendor lock-in comes vulnerability to price increases. So think defensive. Here are our quick defence tactics against cloud vendor lock-in.

**1. Avoid vendor lock-in** Ensure your app is able to move easily to another cloud provider as and when needed. In essence, keep your plan B in implementable shape and prepare plan B before making serious customizations for a specific cloud platform.

**2. Analyze the TCO for language and tools selection** When building your cloud app, think hard about the code selection before you start filling up your git repository. Popular coding languages may not be the most economical for your specific situation. Think of availability of professionals skilled in the coding language of your choice both within and ourside your organization. 

**3. Carefully select your code base** Runtime, scripting environments and code frameworks are not all similar. Discuss with your dev team members on the choice that would be most optimal for you.

**4. Understand redundancy and cloud architecture** Identify single points of failure (SPOF) in the architecture. Judge the redundancy elements for yourself and consult with the experts. 

**5. Tread PaaS land carefully** Explore installable PaaS that you can run yourself if need be. Spread the risk among several different PaaS providers that do not depend on a common IaaS provider.

These tactics are the ones we find most used by our cloud clients in attempting to reduce the impact of vendor lock-in to a good degree. 

Got other ideas on how you would avoid cloud vendor lock-in? Share via comments.
