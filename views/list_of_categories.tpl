% include('common/header.tpl', title=Repository.repository+' categories')
<div class="container">
	<ol class="breadcrumb">
		<li><a href="/">Home</a></li>
		<li class="active">{{Repository.repository}}</li>
	</ol>
	<div class="row">
		<div class="col-lg-12">
			<h2>Categories</h2>
			% if Repository.missing_categories():
			<div class="alert alert-warning" role="alert"><strong>Warning:</strong> {{Repository.repository}}'s profiles/categories file is missing</div>
			% end
			<table class="table table-striped">
			<thead>
				<tr>
					<th>Category</th>
					<th>Description</th>
				</tr>
				% for category in Repository.categories():
				<tr>
					<td><a href="/{{Repository.repository}}/{{category}}">{{category}}</a></td>
				% try:
					<td>{{Repository.category_description(category)}}</td>
				% except FileNotFoundError as e:
					<td class="alert alert-warning"><strong>Warning:</strong> {{str(e)}}</td>
				% end
				</tr>
				% end
			</thead>
			</table>
		</div>
	</div>
</div>
% include('common/footer.tpl')
