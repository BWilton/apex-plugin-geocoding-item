set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,736402901567575055));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,132);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/info_oracleapex_address_validation
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'INFO.ORACLEAPEX.ADDRESS_VALIDATION'
 ,p_display_name => 'Address (validate and display map)'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'FUNCTION Render_Address_Validation ('||unistr('\000a')||
'    p_item                IN APEX_PLUGIN.t_page_item,'||unistr('\000a')||
'    p_plugin              in APEX_PLUGIN.t_plugin,'||unistr('\000a')||
'    p_value               IN VARCHAR2,'||unistr('\000a')||
'    p_is_readonly         IN BOOLEAN,'||unistr('\000a')||
'    p_is_printer_friendly IN BOOLEAN )'||unistr('\000a')||
'    RETURN APEX_PLUGIN.t_page_item_render_result'||unistr('\000a')||
'IS'||unistr('\000a')||
'    l_name              VARCHAR2(30);'||unistr('\000a')||
'    l_result            APEX_PLUGIN.T_PAGE_ITEM_REND'||
'ER_RESULT;'||unistr('\000a')||
'    l_map_width         apex_application_page_items.attribute_01%type := NVL(p_item.attribute_01,''400'');'||unistr('\000a')||
'    l_map_height        apex_application_page_items.attribute_01%type := NVL(p_item.attribute_02,''200'');'||unistr('\000a')||
'    l_show_map          apex_application_page_items.attribute_01%type := p_item.attribute_03;'||unistr('\000a')||
'    l_map_id            apex_application_page_items.attribute_01%type := p_item.attri'||
'bute_04;'||unistr('\000a')||
'    l_advanced_options  apex_application_page_items.attribute_01%type := p_item.attribute_05;'||unistr('\000a')||
'    l_format_address_id apex_application_page_items.attribute_01%type := p_item.attribute_06;'||unistr('\000a')||
'    l_address_array_id  apex_application_page_items.attribute_01%type := p_item.attribute_07;'||unistr('\000a')||
'    l_address_type_id   apex_application_page_items.attribute_01%type := p_item.attribute_08;'||unistr('\000a')||
'    l_location_'||
'id       apex_application_page_items.attribute_01%type := p_item.attribute_09;'||unistr('\000a')||
'    l_item_type         apex_application_page_items.attribute_01%type := p_item.attribute_10;'||unistr('\000a')||
'BEGIN'||unistr('\000a')||
'    IF p_is_readonly OR p_is_printer_friendly '||unistr('\000a')||
'    THEN'||unistr('\000a')||
'        APEX_PLUGIN_UTIL.print_hidden_if_readonly ('||unistr('\000a')||
'            p_item_name           => p_item.name,'||unistr('\000a')||
'            p_value               => p_value,'||unistr('\000a')||
'            p_is_'||
'readonly         => p_is_readonly,'||unistr('\000a')||
'            p_is_printer_friendly => p_is_printer_friendly );'||unistr('\000a')||
'        '||unistr('\000a')||
'        APEX_PLUGIN_UTIL.print_display_only ('||unistr('\000a')||
'            p_item_name        => p_item.name,'||unistr('\000a')||
'            p_display_value    => p_value,'||unistr('\000a')||
'            p_show_line_breaks => FALSE,'||unistr('\000a')||
'            p_escape           => TRUE,'||unistr('\000a')||
'            p_attributes       => p_item.element_attributes );'||unistr('\000a')||
'    ELSE'||unistr('\000a')||
'     '||
'   l_name := APEX_PLUGIN.get_input_name_for_page_item(FALSE);'||unistr('\000a')||
'        --'||unistr('\000a')||
'        APEX_JAVASCRIPT.add_library ('||unistr('\000a')||
'            p_name           => ''https://maps.googleapis.com/maps/api/js?key=&API_KEY.'','||unistr('\000a')||
'            p_directory      => NULL,'||unistr('\000a')||
'            p_version        => NULL,'||unistr('\000a')||
'            p_skip_extension => TRUE );'||unistr('\000a')||
'        --'||unistr('\000a')||
'        APEX_JAVASCRIPT.add_library ('||unistr('\000a')||
'            p_name           => ''in'||
'fo_oracleapex_address_validation.min'','||unistr('\000a')||
'            p_directory      => p_plugin.file_prefix, '||unistr('\000a')||
'            p_version        => NULL,'||unistr('\000a')||
'            p_skip_extension => FALSE );'||unistr('\000a')||
'        --'||unistr('\000a')||
'--    l_result.javascript_function := ''info_oracleapex_address_validation'';'||unistr('\000a')||
'        --'||unistr('\000a')||
'        IF l_show_map = ''ABOVE'''||unistr('\000a')||
'        THEN'||unistr('\000a')||
'            SYS.HTP.PRN(''<div style="width:''||l_map_width||''px;height:''||l_map_heigh'||
't||''px;" id="''||p_item.name||''_MAP"> </div>'');'||unistr('\000a')||
'        END IF;'||unistr('\000a')||
'        --'||unistr('\000a')||
'        SYS.HTP.PRN(''<input type="''||l_item_type||''" name="''||l_name||''" id="''||p_item.name||''" ''||'||unistr('\000a')||
'                    ''value="''||sys.htf.escape_sc(p_value)||''" size="''||p_item.element_width||''" ''||'||unistr('\000a')||
'                    ''maxlength="''||p_item.element_max_length||''" ''||'||unistr('\000a')||
'                    p_item.element_attributes||'' />'');'||unistr('\000a')||
'  '||
'      --'||unistr('\000a')||
'        IF l_show_map = ''BELOW'''||unistr('\000a')||
'        THEN'||unistr('\000a')||
'            SYS.HTP.PRN(''<div style="width:''||l_map_width||''px;height:''||l_map_height||''px;" id="''||p_item.name||''_MAP"> </div>'');'||unistr('\000a')||
'        END IF;'||unistr('\000a')||
'        --'||unistr('\000a')||
'        APEX_JAVASCRIPT.add_onload_code'||unistr('\000a')||
'          ( p_code => ''info_oracleapex_address_validation("''||'||unistr('\000a')||
'                       p_item.name||''", ''||'||unistr('\000a')||
'                         ''{''||APEX_JAVASC'||
'RIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''mapWidth'''||unistr('\000a')||
'                                , p_value     => l_map_width'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''mapHeight'''||unistr('\000a')||
'                                , p_value     => '||
'l_map_height'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''showMap'''||unistr('\000a')||
'                                , p_value     => (l_show_map=''Y'')'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                      '||
'        APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''advancedOptions'''||unistr('\000a')||
'                                , p_value     => (l_advanced_options=''Y'')'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''formatAddressId'''||unistr('\000a')||
'    '||
'                            , p_value     => l_format_address_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''addressArrayId'''||unistr('\000a')||
'                                , p_value     => l_address_array_id'||unistr('\000a')||
'                                , p_add_comma => TR'||
'UE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''addressTypeId'''||unistr('\000a')||
'                                , p_value     => l_address_type_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                   '||
'             ( p_name      => ''locationId'''||unistr('\000a')||
'                                , p_value     => l_location_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''language'''||unistr('\000a')||
'                                , p_value     => v(''FSP_LANGUAGE_PREFERENCE'')'||unistr('\000a')||
'      '||
'                          , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''mapId'''||unistr('\000a')||
'                                , p_value     => COALESCE(l_map_id,p_item.name||''_MAP'')'||unistr('\000a')||
'                                , p_add_comma => FALSE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                    '||
'     ''});'' '||unistr('\000a')||
'          );'||unistr('\000a')||
'        --'||unistr('\000a')||
'        l_result.is_navigable := TRUE;'||unistr('\000a')||
'    END IF;'||unistr('\000a')||
'    --'||unistr('\000a')||
'    RETURN l_result;'||unistr('\000a')||
'    --'||unistr('\000a')||
'END Render_Address_Validation;'||unistr('\000a')||
''
 ,p_render_function => 'Render_Address_Validation'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:SOURCE:ELEMENT:WIDTH:HEIGHT'
 ,p_substitute_attributes => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	This item gives you a single field where you can enter an address.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	The given address is then sent for validation to Googles Geocoding API. If Google knows the address the first match is shown in a Google Map.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Requires a Google Maps &nbsp;API Key</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Add the API Key as an application substitution variable called API_KEY</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.1.1'
 ,p_about_url => 'https://github.com/BWilton/apex-plugin-geocoding-item/blob/master/README.md'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9961997790919391449 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Map Width'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_default_value => '400'
 ,p_display_length => 4
 ,p_max_length => 4
 ,p_is_translatable => false
 ,p_help_text => 'Width of the Google Map which shows the entered address.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9961998371311395283 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Map Height'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_default_value => '250'
 ,p_display_length => 4
 ,p_max_length => 4
 ,p_is_translatable => false
 ,p_help_text => 'Height of the Google Map which shows the entered address.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9961998981485407641 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Show Map'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'BELOW'
 ,p_is_translatable => false
 ,p_help_text => 'Where should the Google Map be displayed? Above or below the Item?'||unistr('\000a')||
''||unistr('\000a')||
'Advanced Users may set this to "Custom" to specify a custom target (e.g. a div) which should hold the Map.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 9961999585640408836 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 9961998981485407641 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Above Item'
 ,p_return_value => 'ABOVE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 9961999990142410152 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 9961998981485407641 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Below Item'
 ,p_return_value => 'BELOW'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 9962000392913410957 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 9961998981485407641 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Custom'
 ,p_return_value => 'CUSTOM'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9962000980839435900 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Map Element ID'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 20
 ,p_max_length => 100
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9961998981485407641 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'CUSTOM'
 ,p_help_text => 'Specify the ID of a HTML Tag which should hold the Google Map, e.g. a certain div-Element on your Page.'||unistr('\000a')||
''||unistr('\000a')||
'Please Note: If specifiying a custom Map target the width and height you specified above is ignored and the size of your element is used.'||unistr('\000a')||
'Also Note that the specified element must have width and height set via CSS style attributes.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9962001577554472801 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Show Advanced Options'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'N'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9962005587942175967 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Formatted Address Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9962001577554472801 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'The Google Geocoding API can return a "formatted" version of the given address.<br />'||unistr('\000a')||
'<br />'||unistr('\000a')||
'Specify the name of the Item this formatted address should be written to (if Google knows this address at all).'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9962002167773488898 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Address Array Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9962001577554472801 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'If your specified address is not unique the Google Geocoding API returns an array of possible matching addresses.<br />'||unistr('\000a')||
'<br />'||unistr('\000a')||
'The Item you specify here will be populated with all returned addresses, separated by a HTML-Break Tag.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9962007279789410150 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Address Type Id'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9962001577554472801 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Google Geocoding type of address that matched the given address most (e.g. street_address, locality, country, ...)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9964319441808479898 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'Location Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9962001577554472801 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Into this Page Item the Google Geocoding API will return the location of the first matched address, e.g. "48.123,16.123"'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 1763605733513201503 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 100
 ,p_prompt => 'Item Type'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'Item'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 1763789608626222685 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 1763605733513201503 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Item'
 ,p_return_value => 'Item'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 1763809615552224628 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 1763605733513201503 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Hidden'
 ,p_return_value => 'Hidden'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '4D4954204C6963656E73650D0A0D0A436F707972696768742028632920323031372C2042656E2057696C746F6E0D0A0D0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E';
wwv_flow_api.g_varchar2_table(2) := '7920706572736F6E206F627461696E696E67206120636F70790D0A6F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F20';
wwv_flow_api.g_varchar2_table(3) := '6465616C0D0A696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730D0A746F207573652C20636F70792C206D6F';
wwv_flow_api.g_varchar2_table(4) := '646966792C206D657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0D0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572';
wwv_flow_api.g_varchar2_table(5) := '736F6E7320746F2077686F6D2074686520536F6674776172652069730D0A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0D0A0D0A5468652061626F766520';
wwv_flow_api.g_varchar2_table(6) := '636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0D0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73';
wwv_flow_api.g_varchar2_table(7) := '206F662074686520536F6674776172652E0D0A0D0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520D0A494D50';
wwv_flow_api.g_varchar2_table(8) := '4C4945442C20494E434C5544494E4720425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0D0A4649544E45535320464F52204120504152544943554C41522050555250';
wwv_flow_api.g_varchar2_table(9) := '4F534520414E44204E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54205348414C4C205448450D0A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D';
wwv_flow_api.g_varchar2_table(10) := '2C2044414D41474553204F52204F544845520D0A4C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0D0A4F';
wwv_flow_api.g_varchar2_table(11) := '5554204F46204F5220494E20434F4E4E454354494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450D0A534F4654574152452E';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 936443101893777641 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_file_name => 'Licence.md'
 ,p_mime_type => 'application/octet-stream'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E20696E666F5F6F7261636C65617065785F616464726573735F76616C69646174696F6E28652C61297B66756E6374696F6E206428297B28702E616476616E6365644F7074696F6E737C7C702E666F726D617441646472657373496429';
wwv_flow_api.g_varchar2_table(2) := '2626247328702E666F726D61744164647265737349642C6E756C6C292C28702E616476616E6365644F7074696F6E737C7C702E6164647265737341727261794964292626247328702E61646472657373417272617949642C6E756C6C292C28702E616476';
wwv_flow_api.g_varchar2_table(3) := '616E6365644F7074696F6E737C7C702E61646472657373547970654964292626247328702E616464726573735479706549642C6E756C6C292C28702E616476616E6365644F7074696F6E737C7C702E6C6F636174696F6E4964292626247328702E6C6F63';
wwv_flow_api.g_varchar2_table(4) := '6174696F6E49642C6E756C6C292C742E73657443656E7465722869292C742E7365745A6F6F6D28702E64656661756C745A6F6F6D292C722E7365744D6170286E756C6C297D66756E6374696F6E206F2865297B722E736574506F736974696F6E28652E67';
wwv_flow_api.g_varchar2_table(5) := '656F6D657472792E6C6F636174696F6E292C722E7365744D61702874292C742E666974426F756E647328652E67656F6D657472792E76696577706F7274297D66756E6374696F6E207328297B6428293B76617220653D6C2E76616C28293B6E2E67656F63';
wwv_flow_api.g_varchar2_table(6) := '6F6465287B616464726573733A652C6C616E67756167653A702E6C616E67756167657D2C66756E6374696F6E28652C61297B7377697463682861297B6361736520676F6F676C652E6D6170732E47656F636F6465725374617475732E4F4B3A6966282870';
wwv_flow_api.g_varchar2_table(7) := '2E616476616E6365644F7074696F6E737C7C702E666F726D6174416464726573734964292626247328702E666F726D61744164647265737349642C655B305D2E666F726D61747465645F61646472657373292C702E616476616E6365644F7074696F6E73';
wwv_flow_api.g_varchar2_table(8) := '7C7C702E6164647265737341727261794964297B666F722876617220643D22222C733D303B733C652E6C656E6774683B732B2B29643D642B655B735D2E666F726D61747465645F616464726573732B223C6272202F3E223B247328702E61646472657373';
wwv_flow_api.g_varchar2_table(9) := '417272617949642C64297D696628702E616476616E6365644F7074696F6E737C7C702E61646472657373547970654964297B666F7228766172206E3D22222C743D303B743C655B305D2E74797065732E6C656E6774683B742B2B296E3D6E2B655B305D2E';
wwv_flow_api.g_varchar2_table(10) := '74797065735B745D2B222C223B247328702E616464726573735479706549642C6E297D28702E616476616E6365644F7074696F6E737C7C702E6C6F636174696F6E4964292626247328702E6C6F636174696F6E49642C655B305D2E67656F6D657472792E';
wwv_flow_api.g_varchar2_table(11) := '6C6F636174696F6E2E6C617428292B222C222B655B305D2E67656F6D657472792E6C6F636174696F6E2E6C6E672829292C6F28655B305D293B627265616B3B6361736520676F6F676C652E6D6170732E47656F636F6465725374617475732E5A45524F5F';
wwv_flow_api.g_varchar2_table(12) := '524553554C54533A7D7D297D766172206E2C742C722C6C3D617065782E6A5175657279282223222B65292C703D617065782E6A51756572792E657874656E64287B6D617057696474683A3430302C6D61704865696768743A3230302C73686F774D61703A';
wwv_flow_api.g_varchar2_table(13) := '2242454C4F57222C6D617049643A652B225F4D4150222C616476616E6365644F7074696F6E733A21312C666F726D61744164647265737349643A6E756C6C2C61646472657373417272617949643A6E756C6C2C616464726573735479706549643A6E756C';
wwv_flow_api.g_varchar2_table(14) := '6C2C6C616E67756167653A22656E222C64656661756C745A6F6F6D3A332C6C6F636174696F6E49643A6E756C6C7D2C61292C693D6E657720676F6F676C652E6D6170732E4C61744C6E6728313732293B69662830213D3D6C2E6C656E677468297B6E3D6E';
wwv_flow_api.g_varchar2_table(15) := '657720676F6F676C652E6D6170732E47656F636F6465723B76617220633D7B7A6F6F6D3A702E64656661756C745A6F6F6D2C63656E7465723A692C6D61705479706549643A676F6F676C652E6D6170732E4D61705479706549642E524F41444D41507D3B';
wwv_flow_api.g_varchar2_table(16) := '743D6E657720676F6F676C652E6D6170732E4D617028646F63756D656E742E676574456C656D656E744279496428702E6D61704964292C63292C723D6E657720676F6F676C652E6D6170732E4D61726B65722C6C2E6368616E67652873292C6C2E636861';
wwv_flow_api.g_varchar2_table(17) := '6E676528297D7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 1823607313491218816 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9961995684377642111 + wwv_flow_api.g_id_offset
 ,p_file_name => 'info_oracleapex_address_validation.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
prompt  ...done
