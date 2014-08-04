% include('common/header.tpl', title=Category.repository + ' ' + Category.category + ' categories')
<div class="container">
	<div class="row">
		<div class="col-lg-12">
			<ol class="breadcrumb">
				<li><a href="/">Home</a></li>
				<li><a href="/{{Category.repository}}">{{Category.repository}}</a></li>
				<li class="active">{{Category.category}}</li>
			</ol>
			<h2>Packages</h2>
			<table class="table table-striped">
			<thead>
				<tr>
					<th>Package</th>
					<th>Description</th>
				</tr>
				% for package in Category.packages():
				<tr>
					<td><a href="/{{Category.repository}}/{{Category.category}}/{{package}}">{{package}}</a></td>
					% try:
					<td>{{Category.package_description(package)}}</td>
					% except KeyError as e:
					<td class="alert alert-danger"><strong>Error:</strong> The ebuild for {{str(e)}} is broken</td>
					% end
				</tr>
				% end
			</thead>
			</table>
		</div>
	</div>
</div>
% include('common/footer.tpl')
