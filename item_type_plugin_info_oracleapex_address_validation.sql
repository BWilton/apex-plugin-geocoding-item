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
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,160);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/info_oracleapex_address_validation
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
'            p_name           => ''http://maps.google.com/maps/api/js?sensor=false'','||unistr('\000a')||
'            p_directory      => NULL,'||unistr('\000a')||
'            p_version        => NULL,'||unistr('\000a')||
'            p_skip_extension => TRUE );'||unistr('\000a')||
'        --'||unistr('\000a')||
'        APEX_JAVASCRIPT.add_library ('||unistr('\000a')||
'            p_name           => ''info_ora'||
'cleapex_address_validation.min'','||unistr('\000a')||
'            p_directory      => p_plugin.file_prefix, '||unistr('\000a')||
'            p_version        => NULL,'||unistr('\000a')||
'            p_skip_extension => FALSE );'||unistr('\000a')||
'        --'||unistr('\000a')||
'--    l_result.javascript_function := ''info_oracleapex_address_validation'';'||unistr('\000a')||
'        --'||unistr('\000a')||
'        IF l_show_map = ''ABOVE'''||unistr('\000a')||
'        THEN'||unistr('\000a')||
'            SYS.HTP.PRN(''<div style="width:''||l_map_width||''px;height:''||l_map_height||''px'||
';" id="''||p_item.name||''_MAP"> </div>'');'||unistr('\000a')||
'        END IF;'||unistr('\000a')||
'        --'||unistr('\000a')||
'        SYS.HTP.PRN(''<input type="''||l_item_type||''" name="''||l_name||''" id="''||p_item.name||''" ''||'||unistr('\000a')||
'                    ''value="''||sys.htf.escape_sc(p_value)||''" size="''||p_item.element_width||''" ''||'||unistr('\000a')||
'                    ''maxlength="''||p_item.element_max_length||''" ''||'||unistr('\000a')||
'                    p_item.element_attributes||'' />'');'||unistr('\000a')||
'        '||
'--'||unistr('\000a')||
'        IF l_show_map = ''BELOW'''||unistr('\000a')||
'        THEN'||unistr('\000a')||
'            SYS.HTP.PRN(''<div style="width:''||l_map_width||''px;height:''||l_map_height||''px;" id="''||p_item.name||''_MAP"> </div>'');'||unistr('\000a')||
'        END IF;'||unistr('\000a')||
'        --'||unistr('\000a')||
'        APEX_JAVASCRIPT.add_onload_code'||unistr('\000a')||
'          ( p_code => ''info_oracleapex_address_validation("''||'||unistr('\000a')||
'                       p_item.name||''", ''||'||unistr('\000a')||
'                         ''{''||APEX_JAVASCRIPT.a'||
'dd_attribute'||unistr('\000a')||
'                                ( p_name      => ''mapWidth'''||unistr('\000a')||
'                                , p_value     => l_map_width'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''mapHeight'''||unistr('\000a')||
'                                , p_value     => l_map_'||
'height'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''showMap'''||unistr('\000a')||
'                                , p_value     => (l_show_map=''Y'')'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                            '||
'  APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''advancedOptions'''||unistr('\000a')||
'                                , p_value     => (l_advanced_options=''Y'')'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''formatAddressId'''||unistr('\000a')||
'          '||
'                      , p_value     => l_format_address_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''addressArrayId'''||unistr('\000a')||
'                                , p_value     => l_address_array_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'   '||
'                             )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''addressTypeId'''||unistr('\000a')||
'                                , p_value     => l_address_type_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                         '||
'       ( p_name      => ''locationId'''||unistr('\000a')||
'                                , p_value     => l_location_id'||unistr('\000a')||
'                                , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''language'''||unistr('\000a')||
'                                , p_value     => v(''FSP_LANGUAGE_PREFERENCE'')'||unistr('\000a')||
'            '||
'                    , p_add_comma => TRUE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                              APEX_JAVASCRIPT.add_attribute'||unistr('\000a')||
'                                ( p_name      => ''mapId'''||unistr('\000a')||
'                                , p_value     => COALESCE(l_map_id,p_item.name||''_MAP'')'||unistr('\000a')||
'                                , p_add_comma => FALSE'||unistr('\000a')||
'                                )||'||unistr('\000a')||
'                         '''||
'});'' '||unistr('\000a')||
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
'	See http://gmaps-samples-v3.googlecode.com/svn/trunk/geocoder/v3-geocoder-tool.html for examples of what the Google Geocoding API is capable of.</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
 ,p_about_url => 'http://www.oracle-and-apex.com/category/plugins'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9028222588521360225 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
  p_id => 9028223168913364059 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
  p_id => 9028223779087376417 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
  p_id => 9028224383242377612 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 9028223779087376417 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Above Item'
 ,p_return_value => 'ABOVE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 9028224787744378928 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 9028223779087376417 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Below Item'
 ,p_return_value => 'BELOW'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 9028225190515379733 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 9028223779087376417 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Custom'
 ,p_return_value => 'CUSTOM'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9028225778441404676 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Map Element ID'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 20
 ,p_max_length => 100
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9028223779087376417 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'CUSTOM'
 ,p_help_text => 'Specify the ID of a HTML Tag which should hold the Google Map, e.g. a certain div-Element on your Page.'||unistr('\000a')||
''||unistr('\000a')||
'Please Note: If specifiying a custom Map target the width and height you specified above is ignored and the size of your element is used.'||unistr('\000a')||
'Also Note that the specified element must have width and height set via CSS style attributes.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9028226375156441577 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
  p_id => 9028230385544144743 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Formatted Address Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9028226375156441577 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'The Google Geocoding API can return a "formatted" version of the given address.<br />'||unistr('\000a')||
'<br />'||unistr('\000a')||
'Specify the name of the Item this formatted address should be written to (if Google knows this address at all).'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9028226965375457674 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Address Array Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9028226375156441577 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'If your specified address is not unique the Google Geocoding API returns an array of possible matching addresses.<br />'||unistr('\000a')||
'<br />'||unistr('\000a')||
'The Item you specify here will be populated with all returned addresses, separated by a HTML-Break Tag.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9028232077391378926 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Address Type Id'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9028226375156441577 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Google Geocoding type of address that matched the given address most (e.g. street_address, locality, country, ...)'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 9030544239410448674 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'Location Item'
 ,p_attribute_type => 'PAGE ITEM'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 9028226375156441577 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => 'Into this Page Item the Google Geocoding API will return the location of the first matched address, e.g. "48.123,16.123"'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 829830531115170279 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
  p_id => 830014406228191461 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 829830531115170279 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Item'
 ,p_return_value => 'Item'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 830034413154193404 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 829830531115170279 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Hidden'
 ,p_return_value => 'Hidden'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E20696E666F5F6F7261636C65617065785F616464726573735F76616C69646174696F6E28682C69297B766172206B2C642C662C6C3D617065782E6A5175657279282223222B68292C613D617065782E6A51756572792E657874656E64';
wwv_flow_api.g_varchar2_table(2) := '287B6D617057696474683A3430302C6D61704865696768743A3230302C73686F774D61703A2242454C4F57222C6D617049643A682B225F4D4150222C616476616E6365644F7074696F6E733A66616C73652C666F726D61744164647265737349643A6E75';
wwv_flow_api.g_varchar2_table(3) := '6C6C2C61646472657373417272617949643A6E756C6C2C616464726573735479706549643A6E756C6C2C6C616E67756167653A22656E222C64656661756C745A6F6F6D3A332C6C6F636174696F6E49643A6E756C6C7D2C69293B76617220673D6E657720';
wwv_flow_api.g_varchar2_table(4) := '676F6F676C652E6D6170732E4C61744C6E6728282D34322C31373229293B66756E6374696F6E206528297B696628612E616476616E6365644F7074696F6E737C7C612E666F726D6174416464726573734964297B247328612E666F726D61744164647265';
wwv_flow_api.g_varchar2_table(5) := '737349642C6E756C6C297D696628612E616476616E6365644F7074696F6E737C7C612E6164647265737341727261794964297B247328612E61646472657373417272617949642C6E756C6C297D696628612E616476616E6365644F7074696F6E737C7C61';
wwv_flow_api.g_varchar2_table(6) := '2E61646472657373547970654964297B247328612E616464726573735479706549642C6E756C6C297D696628612E616476616E6365644F7074696F6E737C7C612E6C6F636174696F6E4964297B247328612E6C6F636174696F6E49642C6E756C6C297D64';
wwv_flow_api.g_varchar2_table(7) := '2E73657443656E7465722867293B642E7365745A6F6F6D28612E64656661756C745A6F6F6D293B662E7365744D6170286E756C6C297D66756E6374696F6E2062286D297B662E736574506F736974696F6E286D2E67656F6D657472792E6C6F636174696F';
wwv_flow_api.g_varchar2_table(8) := '6E293B662E7365744D61702864293B642E666974426F756E6473286D2E67656F6D657472792E76696577706F7274297D66756E6374696F6E206A28297B6528293B766172206D3D6C2E76616C28293B6B2E67656F636F6465287B616464726573733A6D2C';
wwv_flow_api.g_varchar2_table(9) := '6C616E67756167653A612E6C616E67756167657D2C66756E6374696F6E28712C6E297B737769746368286E297B6361736520676F6F676C652E6D6170732E47656F636F6465725374617475732E4F4B3A696628612E616476616E6365644F7074696F6E73';
wwv_flow_api.g_varchar2_table(10) := '7C7C612E666F726D6174416464726573734964297B247328612E666F726D61744164647265737349642C715B305D2E666F726D61747465645F61646472657373297D696628612E616476616E6365644F7074696F6E737C7C612E61646472657373417272';
wwv_flow_api.g_varchar2_table(11) := '61794964297B76617220703D22223B666F722876617220723D303B723C712E6C656E6774683B722B2B297B703D702B715B725D2E666F726D61747465645F616464726573732B223C6272202F3E227D247328612E61646472657373417272617949642C70';
wwv_flow_api.g_varchar2_table(12) := '297D696628612E616476616E6365644F7074696F6E737C7C612E61646472657373547970654964297B76617220733D22223B666F7228766172206F3D303B6F3C715B305D2E74797065732E6C656E6774683B6F2B2B297B733D732B715B305D2E74797065';
wwv_flow_api.g_varchar2_table(13) := '735B6F5D2B222C227D247328612E616464726573735479706549642C73297D696628612E616476616E6365644F7074696F6E737C7C612E6C6F636174696F6E4964297B247328612E6C6F636174696F6E49642C715B305D2E67656F6D657472792E6C6F63';
wwv_flow_api.g_varchar2_table(14) := '6174696F6E2E6C617428292B222C222B715B305D2E67656F6D657472792E6C6F636174696F6E2E6C6E672829297D6228715B305D293B627265616B3B6361736520676F6F676C652E6D6170732E47656F636F6465725374617475732E5A45524F5F524553';
wwv_flow_api.g_varchar2_table(15) := '554C54533A627265616B3B64656661756C743A616C6572742822416E206572726F72206F63637572726564207768696C652076616C69646174696E672074686973206164647265737322297D7D297D6966286C2E6C656E6774683D3D3D30297B72657475';
wwv_flow_api.g_varchar2_table(16) := '726E7D6B3D6E657720676F6F676C652E6D6170732E47656F636F64657228293B76617220633D7B7A6F6F6D3A612E64656661756C745A6F6F6D2C63656E7465723A672C6D61705479706549643A676F6F676C652E6D6170732E4D61705479706549642E52';
wwv_flow_api.g_varchar2_table(17) := '4F41444D41507D3B643D6E657720676F6F676C652E6D6170732E4D617028646F63756D656E742E676574456C656D656E744279496428612E6D61704964292C63293B663D6E657720676F6F676C652E6D6170732E4D61726B657228293B6C2E6368616E67';
wwv_flow_api.g_varchar2_table(18) := '65286A293B6C2E6368616E676528297D3B';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 855009613871377958 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9028220481979610887 + wwv_flow_api.g_id_offset
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
