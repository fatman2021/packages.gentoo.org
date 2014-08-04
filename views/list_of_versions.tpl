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


			% for reason in pkg.mask(Package, Package.package_newest_version()):
			%     if reason.endswith("license(s)"):
			<div class="alert alert-info" role="alert">This package requires acceptance of the {{reason}}</div>
			%     end
			% end


			% try:
			%     recent_change = pkg.recent_changes(Package)
			<!-- <h2>Most recent change</h2> -->
			<div class="well">
			% for line in recent_change:
				{{line}}<br />
			% end
			</div>
			% except FileNotFoundError:
			%    pass
			% end


			<!-- <h2>Arch keywords</h2> -->
			<table class="table table-striped">
			<thead>
				<tr>
					<th>Version</th>
					% for arch in pkg.arch_list():
					<th class="text-center">{{arch}}</th>
					% end
				</tr>
				% for version in Package.versions():
				<tr>
					<td>{{version}}</td>
					% masks = pkg.mask(Package, version)
					% if "missing keyword" in masks:
					%     if "9999" in version:
					<td colspan="{{len(pkg.arch_list())}}" class="text-center alert alert-info">Live ebuild</td>
					%     end
					% elif "package.mask" in masks:
					<td colspan="{{len(pkg.arch_list())}}" class="text-center alert alert-danger">Version is hardmasked</td>
					% else:
					%     try:
					%         for stability in pkg.stability(Package, version):
					%             if stability == "+":
					<td class="text-center alert-success">{{stability}}</td>
					%             elif stability == "~":
					<td class="text-center alert-warning">{{stability}}</td>
					%             elif stability == "-":
					<td class="text-center alert-danger">{{stability}}</td>
					%             else:
					<td></td>
					%             end
					%         end
					%     except KeyError as e:
					<td colspan="{{len(pkg.arch_list())}}" class="text-center alert alert-danger"><strong>Error:</strong> The ebuild for {{str(e)}} is broken</td>
					%     end
					% end
				</tr>
				% end
			</thead>
			</table>
		</div>

		<div class="col-lg-3">
			<h3>Project Homepage</h3>
			<ul class="list-group">
			% homepages = pkg.homepage(Package)
			% for source in homepages:
				<li role="presentation" class="list-group-item"><a href="{{homepages[source]}}">{{source}}</a></li>
			% end
			</ul>


			<div class="dropdown pull-right">
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


			<ul class="list-group">
				<li role="presentation" class="list-group-item"><a href="https://bugs.gentoo.org/buglist.cgi?quicksearch={{Package.category}}%2F{{Package.package}}">Gentoo Bugs</a></li>
			</ul>


			<h3>Keywords legend</h3>
			<div class="list-group">
				<a class="list-group-item list-group-item-success">Verified stable</a>
				<a class="list-group-item list-group-item-warning">Testing incomplete</a>
			</div>

		</div>
	</div>
</div>
% include('common/footer.tpl')
