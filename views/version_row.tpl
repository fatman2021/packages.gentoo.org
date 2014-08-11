% masks = pkg.mask(Package, version)

% if "9999" in version:
%     if "missing keyword" in masks:
%         if "live" in cookies:
<tr>
	<td>{{version}}</td>
	<td colspan="{{len(pkg.arch_list())}}" class="text-center">Live ebuild</td>
</tr>
%         end
%     else:
<tr>
	<td>{{version}}</td>
	<td colspan="{{len(pkg.arch_list())}}" class="text-center alert alert-danger"><strong>Error:</strong> Live ebuild with keywords</td>
</tr>
%     end
% else:
%     if "package.mask" in masks:
<tr>
	<td>{{version}}</td>
	<td colspan="{{len(pkg.arch_list())}}" class="text-center alert alert-danger">Global hardmask</td>
</tr>
%     else:
<tr>
	<td>{{version}}</td>
%         try:
%             for stability in pkg.stability(Package, version):
	<td class="text-center {{pkg.stability_color(stability)}}">{{pkg.stability_text(stability)}}</td>
%             end
%         except KeyError as e:
	<td colspan="{{len(pkg.arch_list())}}" class="text-center alert alert-danger"><strong>Error:</strong> The ebuild for {{str(e)}} is broken</td>
%         end
</tr>
%     end
% end
