% include('common/header.tpl', title='404')
<div class="container">
	<div class="row">
		<div class="col-lg-8">
			<h2>Search</h2>
			<p>The search backend has not been rewritten yet.</p>
		</div>
		% if Overlays.repositories():
		<div class="col-lg-4">
			<h2>Browse available overlays</h2>
			<div class="list-group">
				% for overlay in Overlays.repositories():
				<a href="/{{overlay}}" class="list-group-item">{{overlay}}</a>
				% end
			</div>
		</div>
		% end
	</div>
</div>
% include('common/footer.tpl')
