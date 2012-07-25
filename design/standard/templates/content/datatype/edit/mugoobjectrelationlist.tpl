
<div style="border: solid 1px pink;">
    {let class_content=$attribute.class_content
         class_list=fetch( class, list, hash( class_filter, $class_content.class_constraint_list ) )
         can_create=true()
         new_object_initial_node_placement=false()
         browse_object_start_node=false()}

        {if $class_content.selection_type|ne( 0 )} {* If current selection mode is not 'browse'. *}
            {default attribute_base=ContentObjectAttribute}
                {let parent_node=cond( and( is_set( $class_content.default_placement.node_id ),
                                           $class_content.default_placement.node_id|eq( 0 )|not ),
                                           $class_content.default_placement.node_id, 1 )
                     nodesList=cond( and( is_set( $class_content.class_constraint_list ), $class_content.class_constraint_list|count|ne( 0 ) ),
                                     fetch( content, tree,
                                            hash( parent_node_id, $parent_node,
                                                  class_filter_type,'include',
                                                  class_filter_array, $class_content.class_constraint_list,
                                                  sort_by, array( 'name',true() ),
                                                  main_node_only, true() ) ),
                                     fetch( content, list,
                                            hash( parent_node_id, $parent_node,
                                                  sort_by, array( 'name', true() )
                                                 ) )
                                    )
                }
                    {switch match=$class_content.selection_type}
                        {case match=1} {* Dropdown list *}
                            <div class="buttonblock">
                                <input type="hidden" name="single_select_{$attribute.id}" value="1" />
                                {if ne( count( $nodesList ), 0)}
                                <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
                                    {section show=$attribute.contentclass_attribute.is_required|not}
                                        <option value="no_relation" {section show=eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/section}>{'No relation'|i18n( 'design/standard/content/datatype' )}</option>
                                    {/section}
                                    {section var=node loop=$nodesList}
                                        <option value="{$node.contentobject_id}"
                                        {if ne( count( $attribute.content.relation_list ), 0)}
                                        {foreach $attribute.content.relation_list as $item}
                                             {if eq( $item.contentobject_id, $node.contentobject_id )}
                                                selected="selected"
                                                {break}
                                             {/if}
                                        {/foreach}
                                        {/if}
                                        >
                                        {$node.name|wash}</option>
                                    {/section}
                                </select>
                                {/if}
                            </div>
                        {/case}

                        {case match=2} {* radio buttons list *}
                            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
                            {section show=$attribute.contentclass_attribute.is_required|not}
                                <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation"
                                {section show=eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/section}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />{/section}
                            {section var=node loop=$nodesList}
                                <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                                {if ne( count( $attribute.content.relation_list ), 0)}
                                {foreach $attribute.content.relation_list as $item}
                                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                                            checked="checked"
                                            {break}
                                     {/if}
                                {/foreach}
                                {/if}
                                >
                                {$node.name|wash} <br/>
                            {/section}
                        {/case}

                        {case match=3} {* check boxes list *}
                            {section var=node loop=$nodesList}
                                <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                                {if ne( count( $attribute.content.relation_list ), 0)}
                                {foreach $attribute.content.relation_list as $item}
                                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                                            checked="checked"
                                            {break}
                                     {/if}
                                {/foreach}
                                {/if}
                                />
                                {$node.name|wash} <br/>
                            {/section}
                        {/case}

                        {case match=4} {* Multiple List *}
                            <div class="buttonblock">
                            {if ne( count( $nodesList ), 0)}
                            <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" size="10" multiple>
                                {section var=node loop=$nodesList}
                                    <option value="{$node.contentobject_id}"
                                    {if ne( count( $attribute.content.relation_list ), 0)}
                                    {foreach $attribute.content.relation_list as $item}
                                         {if eq( $item.contentobject_id, $node.contentobject_id )}
                                            selected="selected"
                                            {break}
                                         {/if}
                                    {/foreach}
                                    {/if}
                                    >
                                    {$node.name|wash}</option>
                                {/section}
                            </select>
                            {/if}
                            </div>
                        {/case}

                        {case match=5} {* Template based, multi *}
                            <div class="buttonblock">
                            <div class="templatebasedeor">
                                <ul>
                                {section var=node loop=$nodesList}
                                   <li>
                                        <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                                        {if ne( count( $attribute.content.relation_list ), 0)}
                                        {foreach $attribute.content.relation_list as $item}
                                           {if eq( $item.contentobject_id, $node.contentobject_id )}
                                               checked="checked"
                                               {break}
                                           {/if}
                                        {/foreach}
                                        {/if}
                                        >
                                        {node_view_gui content_node=$node view=objectrelationlist}
                                   </li>
                                {/section}
                                </ul>
                            </div>
                            </div>
                        {/case}

                        {case match=6} {* Template based, single *}
                            <div class="buttonblock">
                            <div class="templatebasedeor">
                            <ul>
                                {section show=$attribute.contentclass_attribute.is_required|not}
                            <li>
                                         <input value="no_relation" type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" {section show=eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/section}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />
                                    </li>
                                {/section}
                                {section var=node loop=$nodesList}
                                    <li>
                                        <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                                        {if ne( count( $attribute.content.relation_list ), 0)}
                                        {foreach $attribute.content.relation_list as $item}
                                           {if eq( $item.contentobject_id, $node.contentobject_id )}
                                               checked="checked"
                                               {break}
                                           {/if}
                                        {/foreach}
                                        {/if}
                                        >
                                        {node_view_gui content_node=$node view=objectrelationlist}
                                    </li>
                                {/section}
                           </ul>
                           </div>
                           </div>
                        {/case}
                    {/switch}

                    {if eq( count( $nodesList ), 0 )}
                        {def $parentnode = fetch( 'content', 'node', hash( 'node_id', $parent_node ) )}
                        {if is_set( $parentnode )}
                            <p>{'Parent node'|i18n( 'design/standard/content/datatype' )}: {node_view_gui content_node=$parentnode view=objectrelationlist} </p>
                        {/if}
                        <p>{'Allowed classes'|i18n( 'design/standard/content/datatype' )}:</p>
                        {if ne( count( $class_content.class_constraint_list ), 0 )}
                             <ul>
                             {foreach $class_content.class_constraint_list as $class}
                                   <li>{$class}</li>
                             {/foreach}
                             </ul>
                        {else}
                             <ul>
                                   <li>{'Any'|i18n( 'design/standard/content/datatype' )}</li>
                             </ul>
                        {/if}
                        <p>{'There are no objects of allowed classes'|i18n( 'design/standard/content/datatype' )}.</p>
                    {/if}

                    {* Create object *}
                    {section show = and( is_set( $class_content.default_placement.node_id ), ne( 0, $class_content.default_placement.node_id ), ne( '', $class_content.object_class ) )}
                        {def $defaultNode = fetch( content, node, hash( node_id, $class_content.default_placement.node_id ))}
                        {if and( is_set( $defaultNode ), $defaultNode.can_create )}
                            <div id='create_new_object_{$attribute.id}' style="display:none;">
                                 <p>{'Create new object with name'|i18n( 'design/standard/content/datatype' )}:</p>
                                 <input name="attribute_{$attribute.id}_new_object_name" id="attribute_{$attribute.id}_new_object_name"/>
                            </div>
                            <input class="button" type="button" value="Create New" name="CustomActionButton[{$attribute.id}_new_object]"
                                   onclick="var divfield=document.getElementById('create_new_object_{$attribute.id}');divfield.style.display='block';
                                            var editfield=document.getElementById('attribute_{$attribute.id}_new_object_name');editfield.focus();this.style.display='none';return false;" />
                       {/if}
                    {/section}
                {/let}
            {/default}
        {else}	{* Standard mode is browsing *}
            {if is_set( $attribute.class_content.default_placement.node_id )}
                 {set browse_object_start_node=$attribute.class_content.default_placement.node_id}
            {/if}
            {* Optional controls. *}
            {include uri='design:content/datatype/edit/mugoobjectrelationlist_controls.tpl'}

            {* Advanced interface. *}
            {section show=eq( ezini( 'BackwardCompatibilitySettings', 'AdvancedObjectRelationList' ), 'enabled' )}
                {section show=$attribute.content.relation_list}
                    <table class="list" cellspacing="0">
                        <tr class="bglight">
                            <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" onclick="ezjs_toggleCheckboxes( document.editform, '{$attribute_base}_selection[{$attribute.id}][]' ); return false;" title="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" /></th>
                            <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
                            <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
                            <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
                            <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
                        </tr>
                        {section name=Relation loop=$attribute.content.relation_list sequence=array( bglight, bgdark )}
                            <tr class="{$:sequence}">
                                {section show=$:item.is_modified}
                                    {* Remove. *}
                                    <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_remove_{$Relation:index}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" /></td>

                                    <td colspan="3">
                                        {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )
                                             version=fetch( content, version, hash( object_id, $:item.contentobject_id, version_id, $:item.contentobject_version ) )}
                                            <fieldset>
                                                <legend>{'Edit <%object_name> [%object_class]'|i18n( 'design/standard/content/datatype',, hash( '%object_name', $Relation:object.name, '%object_class', $Relation:object.class_name ) )|wash}</legend>
                                                {section name=Attribute loop=$:version.contentobject_attributes}
                                                    <div class="block">
                                                        {section show=$:item.display_info.edit.grouped_input}
                                                            <fieldset>
                                                            <legend>{$:item.contentclass_attribute.name}</legend>
                                                            {attribute_edit_gui attribute_base=concat( $attribute_base, '_ezorl_edit_object_', $Relation:item.contentobject_id ) html_class='half' attribute=$:item}
                                                            </fieldset>
                                                        {section-else}
                                                            <label>{$:item.contentclass_attribute.name}:</label>
                                                            {attribute_edit_gui attribute_base=concat( $attribute_base, '_ezorl_edit_object_', $Relation:item.contentobject_id ) html_class='half' attribute=$:item}
                                                        {/section}
                                                    </div>
                                                {/section}
                                            </fieldset>
                                        {/let}
                                    </td>

                                    {* Order. *}
                                    <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_order" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" /></td>
                                {section-else}
                                    {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )}
                                        {* Remove. *}
                                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_remove_{$Relation:index}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" /></td>
                                        {* Name *}
                                        <td>{$Relation:object.name|wash()}</td>
                                        {* Type *}
                                        <td>{$Relation:object.class_name|wash()}</td>
                                        {* Section *}
                                        <td>{fetch( section, object, hash( section_id, $Relation:object.section_id ) ).name|wash()}</td>
                                        {* Order. *}
                                        <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" /></td>
                                    {/let}
                                {/section}
                            </tr>

                            <tr class="{$:sequence}">
                                <td colspan="2" nowrap><b>Cross reference data:</b>
                                </td>
                                <td colspan="3"><textarea cols="80" rows="3" name="{$attribute_base}_xrefoptionaldata[{$attribute.id}][]">{$Objects.xrefoptionaldata}</textarea>
                                </td>
                            </tr>
                        {/section}
                    </table>
                {section-else}
                    <p>{'There are no related objects.'|i18n( 'design/standard/content/datatype' )}</p>
                {/section}

                {section show=$attribute.content.relation_list}
                    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" />&nbsp;
                    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit selected'|i18n( 'design/standard/content/datatype' )}" />
                {section-else}
                    <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />&nbsp;
                    <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
                {/section}

                {section show=array( 0, 2 )|contains( $class_content.type )}
                    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" />
                    {section show=$browse_object_start_node}
                        <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
                    {/section}
                {section-else}
                    <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
                {/section}

                {section show=and( $can_create, array( 0, 1 )|contains( $class_content.type ) )}
                    <div class="block">
                        <select id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" class="combobox" name="{$attribute_base}_new_class[{$attribute.id}]">
                            {section name=Class loop=$class_list}
                                <option value="{$:item.id}">{$:item.name|wash}</option>
                            {/section}
                        </select>
                        {section show=$new_object_initial_node_placement}
                            <input type="hidden" name="{$attribute_base}_object_initial_node_placement[{$attribute.id}]" value="{$new_object_initial_node_placement|wash}" />
                        {/section}
                        <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_new_class]" value="{'Create new object'|i18n( 'design/standard/content/datatype' )}" />
                    </div>
                {/section}

            {* Simple interface. *}
            {section-else}
                {section show=$attribute.content.relation_list}
                    <table class="list" cellspacing="0">
                        <tr>
                            <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" onclick="ezjs_toggleCheckboxes( document.editform, '{$attribute_base}_selection[{$attribute.id}][]' ); return false;" title="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" /></th>
                            <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
                            <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
                            <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
                            <th>{'Published'|i18n( 'design/standard/content/datatype' )}</th>
                            <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
                        </tr>
                        {section var=Objects loop=$attribute.content.relation_list sequence=array( bglight, bgdark )}
                            {let object=fetch( content, object, hash( object_id, $Objects.item.contentobject_id ) )}
                                <tr class="{$Objects.sequence}">
                                    {* Remove. *}
                                    <td><input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$Objects.item.contentobject_id}" /></td>
                                    {* Name *}
                                    <td>{$object.name|wash()}</td>
                                    {* Type *}
                                    <td>{$object.class_name|wash()}</td>
                                    {* Section *}
                                    <td>{fetch( section, object, hash( section_id, $object.section_id ) ).name|wash()}</td>
                                    <td>{if $Objects.item.in_trash|not() }
                                            {'Yes'|i18n( 'design/standard/content/datatype' )}
                                            {else}
                                            {'No'|i18n( 'design/standard/content/datatype' )}
                                        {/if}
                                    </td>
                                    {* Order. *}
                                    <td><input size="2"
                                                  type="text"
                                                  name="{$attribute_base}_priority[{$attribute.id}][]"
                                                  value="{$Objects.item.priority}" /></td>
                                </tr>

                                <tr class="{$Objects.sequence}">
                                    <td colspan="2" nowrap><b>Cross reference data:</b>
                                    </td>
                                    <td colspan="5"><textarea cols="80" rows="3" name="{$attribute_base}_xrefoptionaldata[{$attribute.id}][]">{$Objects.xrefoptionaldata}</textarea>
                                    </td>
                                </tr>
                            {/let}
                        {/section}
                    </table>
                {section-else}
                    <p>{'There are no related objects.'|i18n( 'design/standard/content/datatype' )}</p>
                {/section}

                {section show=$attribute.content.relation_list}
                    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" />&nbsp;
                {section-else}
                    <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />&nbsp;
                {/section}

                {section show=$browse_object_start_node}
                    <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
                {/section}
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" />
            {/section}
        {/if}
    {/let}
</div>

