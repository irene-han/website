<?php
/**
 * @file
 * gms_text.field_group.inc
 */

/**
 * Implements hook_field_group_info().
 */
function gms_text_field_group_info() {
  $export = array();

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_context|node|text|form';
  $field_group->group_name = 'group_context';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'text';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Context',
    'weight' => '5',
    'children' => array(
      0 => 'field_critical_conversation',
      1 => 'field_intro_manuscript',
      2 => 'field_introduction_to_the_text',
      3 => 'field_keywords',
      4 => 'field_about_edition',
      5 => 'field_credits',
    ),
    'format_type' => 'fieldset',
    'format_settings' => array(
      'formatter' => 'collapsible',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-context field-group-fieldset',
        'required_fields' => 1,
        'id' => '',
      ),
    ),
  );
  $export['group_context|node|text|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_files|node|text|form';
  $field_group->group_name = 'group_files';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'text';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Files',
    'weight' => '4',
    'children' => array(
      0 => 'field_image',
      1 => 'field_tei_file',
      2 => 'field_icon',
      3 => 'field_audio',
      4 => 'field_icon_source',
    ),
    'format_type' => 'fieldset',
    'format_settings' => array(
      'formatter' => 'collapsible',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-files field-group-fieldset',
        'required_fields' => 1,
        'id' => '',
      ),
    ),
  );
  $export['group_files|node|text|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_left|node|text|default';
  $field_group->group_name = 'group_left';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'text';
  $field_group->mode = 'default';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => '',
    'weight' => '1',
    'children' => array(
      0 => 'field_vm_link',
      1 => 'field_icon',
      2 => 'field_icon_source',
      3 => 'group_metadata',
    ),
    'format_type' => 'div',
    'format_settings' => array(
      'label' => '',
      'instance_settings' => array(
        'classes' => 'layout-3col__left-sidebar',
        'description' => '',
        'show_label' => '0',
        'label_element' => 'h3',
        'effect' => 'none',
        'speed' => 'fast',
      ),
      'formatter' => 'open',
    ),
  );
  $export['group_left|node|text|default'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_metadata|node|text|default';
  $field_group->group_name = 'group_metadata';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'text';
  $field_group->mode = 'default';
  $field_group->parent_name = 'group_left';
  $field_group->data = array(
    'label' => 'Text Information',
    'weight' => '5',
    'children' => array(
      0 => 'field_genre',
      1 => 'field_language',
      2 => 'field_period',
      3 => 'field_tei_file',
      4 => 'field_keywords',
      5 => 'field_author',
    ),
    'format_type' => 'div',
    'format_settings' => array(
      'label' => 'Text Information',
      'instance_settings' => array(
        'classes' => 'text-information',
        'description' => '',
        'show_label' => '1',
        'label_element' => 'h3',
        'effect' => 'none',
        'speed' => 'fast',
      ),
      'formatter' => 'collapsible',
    ),
  );
  $export['group_metadata|node|text|default'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_metadata|node|text|form';
  $field_group->group_name = 'group_metadata';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'text';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Metadata',
    'weight' => '6',
    'children' => array(
      0 => 'field_genre',
      1 => 'field_language',
      2 => 'field_period',
      3 => 'field_year',
      4 => 'field_author',
    ),
    'format_type' => 'fieldset',
    'format_settings' => array(
      'formatter' => 'collapsible',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-metadata field-group-fieldset',
        'required_fields' => 1,
        'id' => '',
      ),
    ),
  );
  $export['group_metadata|node|text|form'] = $field_group;

  $field_group = new stdClass();
  $field_group->disabled = FALSE; /* Edit this to true to make a default field_group disabled initially */
  $field_group->api_version = 1;
  $field_group->identifier = 'group_right|node|text|default';
  $field_group->group_name = 'group_right';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'text';
  $field_group->mode = 'default';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => '',
    'weight' => '2',
    'children' => array(
      0 => 'field_critical_conversation',
      1 => 'field_intro_manuscript',
      2 => 'field_introduction_to_the_text',
      3 => 'field_about_edition',
      4 => 'field_credits',
    ),
    'format_type' => 'div',
    'format_settings' => array(
      'label' => '',
      'instance_settings' => array(
        'classes' => 'layout-3col__right-content',
        'description' => '',
        'show_label' => '0',
        'label_element' => 'h3',
        'effect' => 'none',
        'speed' => 'fast',
      ),
      'formatter' => 'open',
    ),
  );
  $export['group_right|node|text|default'] = $field_group;

  return $export;
}
