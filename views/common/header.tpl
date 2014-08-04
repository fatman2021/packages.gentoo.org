<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>{{title or 'Gentoo Packages'}}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link href="https://1b9a50f4f9de4348cd9f-e703bc50ba0aa66772a874f8c7698be7.ssl.cf5.rackcdn.com/bootstrap.min.css" rel="stylesheet" media="screen" />
	<link href="https://1b9a50f4f9de4348cd9f-e703bc50ba0aa66772a874f8c7698be7.ssl.cf5.rackcdn.com/tyrian.min.css" rel="stylesheet" media="screen" />
	<link rel="icon" href="https://www.gentoo.org/favicon.ico" type="image/x-icon" />
</head>
<body>
<header>
	<div class="site-title">
		<div class="container">
			<div class="row">
				<div class="site-title-buttons">
					<div class="btn-group btn-group-sm">
						<a href="http://get.gentoo.org/" type="button" class="btn get-gentoo"><span class="fa fa-download"></span> <strong>Get Gentoo!</strong></a>
						<div class="btn-group btn-group-sm">
							<button type="button" class="gentoo-org-sites btn" data-toggle="dropdown">
								<span class="glyphicon glyphicon-globe"></span> gentoo.org sites <span class="caret"></span>
							</button>
							<ul class="dropdown-menu">
								<li><a href="http://www.gentoo.org/" title="Main Gentoo website"><span class="fa fa-home fa-fw"></span> gentoo.org</a></li>
								<li><a href="http://wiki.gentoo.org/" title="Find and contribute documentation"><span class="fa fa-file-text fa-fw"></span> Wiki</a></li>
								<li><a href="https://bugs.gentoo.org/" title="Report issues and find common issues"><span class="fa fa-bug fa-fw"></span> Bugs</a></li>
								<li><a href="http://forums.gentoo.org/" title="Discuss with the community"><span class="fa fa-comments-o fa-fw"></span> Forums</a></li>
								<li><a href="http://packages.gentoo.org/" title="Find software for your Gentoo"><span class="fa fa-hdd-o fa-fw"></span> Packages</a></li>
								<li class="divider"></li>
								<li><a href="http://overlays.gentoo.org/" title="Collaborate on maintaining packages"><span class="fa fa-code-fork fa-fw"></span> Overlays</a></li>
								<li><a href="http://planet.gentoo.org/" title="Find out what's going on in the developer community"><span class="fa fa-rss fa-fw"></span> Planet</a></li>
								<li><a href="http://archives.gentoo.org/" title="Read up on past discussions"><span class="fa fa-archive fa-fw"></span> Archives</a></li>
								<li><a href="http://sources.gentoo.org/" title="Browse our source code"><span class="fa fa-code fa-fw"></span> Sources</a></li>
								<li class="divider"></li>
								<li><a href="http://infra-status.gentoo.org/" title="Get updates on the services provided by Gentoo"><span class="fa fa-tasks fa-fw"></span> Infra Status</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="logo">
					<img src="https://1b9a50f4f9de4348cd9f-e703bc50ba0aa66772a874f8c7698be7.ssl.cf5.rackcdn.com/site-logo.png" alt="Gentoo Linux Logo"/>
					<span class="site-label">Packages</span>
				</div>
			</div>
		</div>
	</div>
	<nav class="tyrian-navbar" role="navigation">
		<div class="container">
			<div class="row">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div>
				<div class="collapse navbar-collapse navbar-main-collapse">
					<ul class="nav navbar-nav">
						<li><a href="/">Home</a></li>
						<li><a href="/{{Overlays.DEFAULT}}">Categories</a></li>
						% if Overlays.repositories():
						<li class="dropdown">  
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">
								Overlays
								<b class="caret"></b>
							</a>
							<ul class="dropdown-menu">
								% for overlay in Overlays.repositories():
								<li><a href="/{{overlay}}">{{overlay}}</a></li>
								% end
							</ul>
						</li>
						% end
					</ul>
<!-- 					<form class="navbar-form navbar-right" role="search">
						<div class="form-group">
							<input type="text" class="form-control" placeholder="Search" />
						</div>
						<button type="submit" class="btn btn-default">Search</button>
					</form> -->
 				</div>
			</div>
		</div>
	</nav>
</header>