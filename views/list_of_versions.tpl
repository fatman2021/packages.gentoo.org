% include('common/header.tpl', title=Package.repository + ' ' + Package.category + '/' + Package.package)
<div class="container">
	<div class="row">
		<div class="col-lg-9">
			<ol class="breadcrumb">
				<li><a href="/">Home</a></li>
				<li><a href="/{{Package.repository}}">{{Package.repository}}</a></li>
				<li><a href="/{{Package.repository}}/{{Package.category}}">{{Package.category}}</a></li>
				<li class="active">{{Package.package}}</li>
			</ol>


			<h1>{{Package.category}}/{{Package.package}}</h1>
			<p>{{Package.package_description()}}</p>


			% recent_change = pkg.recent_changes(Package)
			% if recent_change:
			<h2>Most recent change</h2>
			<div class="well">
			%     for line in recent_change:
				{{line}}<br />
			%     end
			</div>
			% end


			<h2>Keywords</h2>
			<table class="table table-striped">
			<thead>
				<tr>
					<th>Version</th>
					% for arch in pkg.arch_list():
					<th class="text-center">{{arch}}</th>
					% end
				</tr>
				% for version in Package.versions():
				% include('version_row.tpl')
				% end
			</thead>
			</table>

			% if 'app.use_flags' in CONFIG:
			<h2>Use flags</h2>
			<table class="table table-striped">
			<thead>
				<tr>
					<th>Use flag</th>
					<th>Description</th>
				</tr>
				% default_use = pkg.default_use(Package)
				% for use_flag in pkg.use(Package):
				<tr>
					% if use_flag[0] in default_use:
					<td><span class="fa fa-check-circle-o"></span> {{use_flag[0]}}</td>
					% else:
					<td><span class="fa fa-circle-o"></span> {{use_flag[0]}}</td>
					% end
					<td>{{use_flag[1]}}</td>
				</tr>
				% end
			</thead>
			</table>
			% end
		</div>

		<div class="col-lg-3">
			<h3>Project links</h3>
			<ul class="list-group">
			% upstream = pkg.upstream(Package)
			% homepages = pkg.homepage(Package)
			% for source in homepages:
				<li role="presentation" class="list-group-item"><span class="fa fa-home"></span> <a href="{{homepages[source]}}">{{source}}</a></li>
			% end
			% if upstream:
			%     for source in upstream.bugtrackers:
				<li role="presentation" class="list-group-item"><span class="fa fa-bug"></span> <a href="{{source}}">Bug tracker</a></li>
			%     end
			%     for source in upstream.docs:
				<li role="presentation" class="list-group-item"><span class="fa fa-info-circle"></span> <a href="{{source}}">Documentation</a></li>
			%     end
			%     for source in upstream.changelogs:
				<li role="presentation" class="list-group-item"><span class="fa fa-file-text-o"></span> <a href="{{source}}">Changelog</a></li>
			%     end
			% end
			</ul>


			<h3>Gentoo links</h3>
			<ul class="list-group">
				<li role="presentation" class="list-group-item"><span class="fa fa-bug"></span>  <a href="https://bugs.gentoo.org/buglist.cgi?quicksearch={{Package.category}}%2F{{Package.package}}">Bug tracker</a></li>
				<li role="presentation" class="list-group-item"><span class="fa fa-file-text-o"></span> <a href="http://sources.gentoo.org/viewcvs.py/gentoo-x86/{{Package.category}}/{{Package.package}}/ChangeLog?view=markup">Changelog</a></li>

			</ul>


<!-- 			<h3>Keywords legend</h3>
			<div class="list-group">
				<a class="list-group-item list-group-item-success">Verified stable</a>
				<a class="list-group-item list-group-item-warning">Testing incomplete</a>
			</div> -->

			<div class="dropdown">
				<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
				Select Arches
				<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
				<li role="presentation"><a role="menuitem" tabindex="-1" href="/{{Package.repository}}/{{Package.category}}/{{Package.package}}">Default</a></li>
				<li role="presentation"><a role="menuitem" tabindex="-1" href="#">64 bit</a></li>
				<li role="presentation"><a role="menuitem" tabindex="-1" href="#">FreeBSD</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
% include('common/footer.tpl')
