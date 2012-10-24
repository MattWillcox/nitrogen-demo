%% -*- mode: nitrogen -*-
-module (written_comparison).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Nitrogen Comparisons".

body() -> 
    [
        #panel {id=intro, style="margin: 50px 100px; font-size:small;", body=
        [
        #h1 {text = "Nitrogen Comparisons"},

        #singlerow {style="width: 700px;", cells=[
            #tablecell { align=center, body=#link { text="Summary of Nitrogen", postback=clicked_Summary }},
            #tablecell { align=center, body=#link { text="Comparison to Chicago Boss", postback=clicked_Chicago }},
            #tablecell { align=center, body=#link { text="Comparison to Zotonic", postback=clicked_Zotonic}},
            #tablecell { align=center, body=#link { text="Comparison to CodeIgniter", postback=clicked_CodeIgniter }}
        ]},

        #panel {id=data, style="margin: 20px 0px;", body=[
        "<center><heading2><u>Nitrogen</u><heading2></center>
        <p>
        Nitrogen is a lightweight event-driven web framework for Erlang functional programming language. Running on top of Mochiweb, Inets, Yaws, or Misultin web servers, it is highly stable and scalable web framework, that allows fast development of a web page. As it is written in Erlang, it inherits most of the advantages of Erlang, such as hot code swapping, scalability, stability, robustness, fault tolerance, and so on. In addition, it supports built-in JSON for data passing, asynchronous communication between client and server using built-in AJAX and Comet, client-side scripting using jQuery and jQuery UI, and so on. Nitrogen is also very flexible as the framework can be run on any platform that can run Erlang and any of above mentioned web servers.
        <p>
        It, however, also has some drawbacks to it. Although powerful, Erlang, or functional programming language itself may be new to many of the developers, and therefore, it is expected to have high learning curve. In addition, as Nitrogen is lightweight and has to sometimes depend on third-party libraries or drivers, developers new to the framework has to spend much time to get themselves familiarized with not only Erlang and Nitrogen, but the third-party libraries as well. Furthermore, Nitrogen is considered to be new technology, compared to other web frameworks. Due to this reason, the community is quite small and documentation is very limited.
        <p>
        Although there are some drawbacks, most of them are related to learning the technology, and considering its powerful features, it may be worth the pain, and it will benefit many developers. In the other sections of this page, Nitrogen is compared to others technologies in more detail.
        <p>"
        ]}

        ]}
    ].

event(clicked_Summary) ->
    wf:update(data, #panel {style="margin: 20px 0px;", body=[
        "<center><heading2><u>Nitrogen</u><heading2></center>
        <p>
        Nitrogen is a lightweight event-driven web framework for Erlang functional programming language. Running on top of Mochiweb, Inets, Yaws, or Misultin web servers, it is highly stable and scalable web framework, that allows fast development of a web page. As it is written in Erlang, it inherits most of the advantages of Erlang, such as hot code swapping, scalability, stability, robustness, fault tolerance, and so on. In addition, it supports built-in JSON for data passing, asynchronous communication between client and server using built-in AJAX and Comet, client-side scripting using jQuery and jQuery UI, and so on. Nitrogen is also very flexible as the framework can be run on any platform that can run Erlang and any of above mentioned web servers.
        <p>
        It, however, also has some drawbacks to it. Although powerful, Erlang, or functional programming language itself may be new to many of the developers, and therefore, it is expected to have high learning curve. In addition, as Nitrogen is lightweight and has to sometimes depend on third-party libraries or drivers, developers new to the framework has to spend much time to get themselves familiarized with not only Erlang and Nitrogen, but the third-party libraries as well. Furthermore, Nitrogen is considered to be new technology, compared to other web frameworks. Due to this reason, the community is quite small and documentation is very limited.
        <p>
        Although there are some drawbacks, most of them are related to learning the technology, and considering its powerful features, it may be worth the pain, and it will benefit many developers. In the other sections of this page, Nitrogen is compared to others technologies in more detail.
        <p>"
        ]}
    );

event(clicked_Chicago) ->
    wf:update(data, #panel {style="margin: 20px 0px;",body=[
        "<center><heading2><u>Chicago Boss</u><heading2></center>
        <p>
        Chicago Boss is another Erlang based framework. While nitrogen
        mostly shines on the front end, Chicago boss shines on the backend.
        Both frameworks are event driven and feature all the same benefits 
        of using the Erlang language such as scalability, stability, hot code 
        swapping and etc. Both of them also implement COMET web techniques for 
        asynchronously pushing data to the browser. They both also use JSON generation
        for data interchange.
        <p>
        Chicago Boss has a few more features than Nitrogen does. It is a 
        full MVC based framework. It also provides API functions for sending and
        receiving email. It has a built-in administration web interface that allows
        you to do shell functions through the web. It can automatically recompile 
        using its development server which also prints error messages in the browser
        and includes its own interactive console. 
        <p>
        Chicago Boss also ships with a unique functional test framework, where tests are structured 
        as trees of continuations. It also features built-in validation machinery and an automatic Edoc
        which will make a document that tells you about all the functions
        generated for each model. 
        <p>
        It supports template localization and utf-8 in Erlang code. For templating it features 
        an Erlang implementation of the Django Template Language. Chicago Boss is considered to 
        be more 'Rails/Django-esque'.
        <p>
        There is also support for many data bases. BossDB is a database abstraction
        layer used for querying and updating the database. It currently supports Tokyo Tyrant,
        Mnesia, MySQL, Riak and PostgreSQL databases."    
        ]} 
    );

event(clicked_Zotonic) ->
    wf:update(data, #panel {style="margin: 20px 0px;", body=[
        "<heading2><u><center>Zotonic</center></u><heading2>
        <p>
        Zotonic is a web application framework built with Erlang. Like Nitrogen, Zotonic inherited various advantages of Erlang that would help in creating large scale, multi-process and distributed programs, such as hot code swapping and stability. One of the differences between the two frameworks would be that Zotonic is also a content-management system (CMS), which can be use to create content rich website easily. 
        <p>
        Zotonic employs a MVC structure, while Nitrogen adopted an Event-driven development process. MVC is the recent trend to build complex web applications, and the controller helps in separating action code from presentation code. The downside would be that developers using Zotonic would find themselves spending time on figuring out the controller and it’s constraints as well as trying to save every form in a database. Nitrogen developers never need to worry about saving data from the previous form since Nitrogen allows you to specify the next view based on the previous view, previous events, or any combination of these as well as gi. 
        <p>
        Another major differences is that Zotonic ties to a database, namely PostgreSQL, which gives away some flexibility when developing large scale applications. Nitrogen, in the other hand, does not require a database. In fact, a Nitrogen developer would have to go to some third party libraries if he wants to use a database.
        <p>
        Learning to use Nitrogen might be more challenging than learning Zotonic due to the fact that Nitrogen has very limited documentation while Zotonic had a much larger community and more online resources.  
        "   
        ]}  
    );
event(clicked_CodeIgniter) ->
    wf:update(data, #panel {style="margin: 20px 0px;", body=[
        "<heading2><u><center>CodeIgniter</center></u><heading2>
        <p>
        The most prominent difference between CodeIgniter and the Nitrogen Framework is that one is MVC, PHP-based, and user-friendly while the latter is event-driven, written in full-stack Erlang, and gauged towards the enthusiast programmer who is interested in exploring new tools and seeing if they can get an edge by eschewing orthodox frameworks.    
        <p>  
        Let's get into details. CodeIgniter is easily installed to your typical XAMP setup (what is usually LAMP - Linux, Apache, MySQL, PHP - but on any OS!) but can also be configured to work with other servers and databases.  In the usual case it's just a matter of moving files to the proper folder and changing a few lines of code.  Overall it's nothing cutting-edge, but it gives a pretty good base and guideline for developing your website/webapp.
        <p>  
        On the other hand, Nitrogen is a bit more complicated to install, however the Nitrogen website <em>does</em> provide packages for those intimidated with the concept of using the command-line.  With Nitrogen, you have more choices presented to you, in particular which webserver to run.  These choices seem daunting at first but the reality is that any webserver will do you just fine - it can be changed later with a line of code.  The real advantage here is the <em>flexibility</em> that Nitrogen provides to fill your webapps requirements.  Note: don't let anyone fool you, Nitrogen can still integrate with MySQL or other databases with some additional configuration.
        <p>
        In terms of development, you're writing less code with Nitrogen.  You're also (hopefully) writing more efficient code.  You're also (hopefully) developing kickass event-driven webapps that run on super-efficient, scalable webservers that require very little hardware to power. 
        <p> 
        If you're developing with CodeIgniter you're developing a different kind of webapp.  You're going to be dealing with large amounts of code, in lots of different places, handling controller, model, and views for each page.  This isn't a bad thing, it just means that CodeIgniter is better suited to creating large, sprawling webapps that require a lot of backend support (the most notable difference would be ease of setting up your database."

        ]}
    ).

