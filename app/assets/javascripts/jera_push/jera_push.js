//= require jquery
//= require jquery_ujs
//= require ./jquery-2.1.4.js
//= require ./materialize/bin/materialize.js

$(document).ready(function(){
  $('select').material_select();

  $('#device_attributes').hide();

  $('#message_options input[type=radio]').on('change', function(){
    if($(this)[0].value == 'broadcast'){
      $('#device_attributes').hide();
    } else {
      $('#device_attributes').show();
    }
  });

});

function newMessageAttribute(){
  var lastAttributes = $('.message-attributes:last').clone();
  lastAttributes.find('input').val('');
  $('#message_attributes_content').append(lastAttributes);
};

function removeMessageAttribute(scope){
  if($('.message-attributes').length > 1){
    scope.parent().remove();
  }
};

function addAllDevices(){
  var devices = $('#device_list_checkbox tr input'), devices_input = '';
  for(var i = 0, l = devices.length; i < l; i++){
    var checkboxValue = devices[0].value;
    devices_input += "<input type='text' name='devices[]' value=" + checkboxValue + " >";
  }
  devices.prop('checked', true);
  $('#message_devices').append(devices_input);
};

function removeAllDevices(){
  $('#message_devices').empty();
  $('#device_list_checkbox tr input').prop('checked', false);
}