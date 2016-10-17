![Jera Logo](http://jera.com.br/images/logo-jera-header.png)

JeraPush is a easy tool to work with push messages and firebase API.

It's composed for:

 * [Device](#devices): model responsible for register and interact with device tokens.
 * [Message](#messages): model responsible for register the message content and status after sent.
 * [MessageDevice](#message-devise): model responsible for connect the message sent and the target devices.
 * [Firebase::Client](#firebase-client): class responsible for interact with Firebase.

---

## Features
* Send push messages with Firebase
* Rest Routes to register and remove devices
* Web Interface

---

## Getting started

Add it to your Gemfile:
~~~ruby
gem 'jera_push', git: 'git@bitbucket.org:jerasoftware/jera-push-gem.git'
~~~
Run the `bundle install` command to install it.

Next, you need to run the generator and inform the model to associate with devices. You can do it with this command:
~~~bash
$> rails generate jera_push MODEL_NAME
~~~

That command will create the necessary migrations and the initialize file. The file will be like this:
```ruby
#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  config.firebase_api_key = "YOUR_API_KEY"
  config.resource_name = "User"

  # Resource attribute showed in views
  # config.resource_attributes = [:email, :name]
end

```
---

## Firebase::Client
> Class responsible for interact with Firebase.

### Methods
* instance `static`
* add_device_to_topic
* add_devices_to_topic
* remove_device_from_topic

#### `instance()`
Gets the client instance.

```ruby
client = JeraPush::Firebase::Client.instance
```

#### `add_device_to_topic(topic: String, device: Object)`
Subscribe the device to topic.

```ruby
client = JeraPush::Firebase::Client.instance
client.add_device_to_topic(topic: 'your_topic', device: JeraPush::Device.first)
```

#### `add_devices_to_topic(topic: String, devices: Array)`
Subscribe the devices to topic.

```ruby
client = JeraPush::Firebase::Client.instance
client.add_devices_to_topic(topic: 'your_topic', devices: JeraPush::Device.last(5))
```

#### `remove_device_from_topic(topic: String, devices: Array)`
Unsubscribe the devices to topic.

```ruby
client = JeraPush::Firebase::Client.instance
client.remove_device_from_topic(topic: 'your_topic', devices: JeraPush::Device.last(5))
client.remove_device_from_topic(topic: 'your_topic', devices: [JeraPush::Device.last]) # For one object
```
---

## Device

> Model responsible for register and interact with device tokens to send push messages.

### Attributes

| Attribute|    Type    | Description |
|----------|------------|-------------|
| Token | String | Token for target device |
| Platform | Enumerize | Type of device platform. Can be `:ios`, `:android` or `:chrome` |

### Methods

* send_message
* subscribe
* unsubscribe

#### `send_message(Hash)`
Sends push message to current device.

```ruby
JeraPush::Device.first.send_message({ body: 'Hello World', title: 'Hey' })
```

#### `subscribe(String)`
Subscribe current device to topic.

```ruby
JeraPush::Device.first.subscribe('your_topic')
```

#### `unsubscribe(String)`
Unsubscribes current device from topic.

```ruby
JeraPush::Device.first.unsubscribe('your_topic')
```
---

## Message

> Model responsible for register the message content and status after sent.

### Attributes

| Attribute|    Type    | Description |
|----------|------------|-------------|
| content | Text | Message content |
| status | Enumerize | Message status after sending |
| failure_count | Integer | failure count after sending |
| success_count | Integer | success count after sending |

### Methods
* send_to `static`
* send_to_devices
* send_to_device

#### `send_to(Object or ActiveRecord_Relation, content: {})`
Creates message with content and relates with object or collection, then sends push message.

- One Object
```ruby
JeraPush::Message.send_to(JeraPush::Device.first, content: { body: 'Hello World', title: 'Hey' })
```

- Active Record Relation
```ruby
JeraPush::Message.send_to(JeraPush::Device.where('id < 10'), content: { body: 'Hello World', title: 'Hey' })
```

#### `send_to_devices(Array)`
Sends current message to targets devices.

```ruby
JeraPush::Message.first.send_to_devices(devices: JeraPush::Device.last(3))
```

#### `send_to_device(Object)`
Sends current message to one target device.

```ruby
JeraPush::Message.first.send_to_device(device: JeraPush::Device.last)
```