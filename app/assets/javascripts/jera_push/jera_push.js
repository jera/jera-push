//= require jquery
//= require jquery_ujs
//= require ./jquery-2.1.4.js
//= require ./materialize/bin/materialize.js

$(document).ready(function(){
  $('select').material_select();
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