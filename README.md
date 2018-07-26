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
gem 'jera_push'
~~~

Run the `bundle install` command to install it.

Next, you need to run the generator and inform the model to associate with devices, you can add multiple models . You can do it with this command:
~~~bash
$> rails generate jera_push MODEL_NAME
~~~

That command will create the necessary migrations and the initialize file. The file will be like this:
```ruby
#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  config.firebase_api_key = "YOUR_API_KEY"
  #Update this for every new model
  config.resources_name = ["User"]

  ######################################################
  # Resource attribute showed in views                 #
  # IMPORTANT: All models need to have this attributes #
  # config.resource_attributes = [:email, :name]       #
  ######################################################
  
  # Topic default
  # You should put with your environment
  config.default_topic = 'jera_push_staging'

  # Admin credentials
  # config.admin_login = {
  #   username: 'jera_push',
  #   password: 'JeraPushAdmin'
  # }
end

```
### You has to change the default_topic for your environment, because that's the topic that a brodcast sends a message, and it wouldn't be the same in diferents environment
---

### Scheduling Messages
This gem doesn't support scheduled messages yet. For it, you need implement your own solution with another service like [Sidekiq](https://github.com/mperham/sidekiq), [Whenever](https://github.com/javan/whenever), [Rufus](https://github.com/jmettraux/rufus-scheduler) or other.

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
* send_broadcast `static`
* send_to `static`
* send_to_devices
* send_to_device

#### `send_broadcast(content: {})`
Sends message to all registered devices.

```ruby
JeraPush::Message.broadcast(content: { body: 'Hello World', title: 'Hey' })
```

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

---

## API - Current Version: **V1**

### Endpoints

#### Create a device
> /jera_push/v1/devices | `POST`

| Parameter |    Type    | Description |
|----------|------------|-------------|
| token `required` | String | Device token which will be registred |
| platform `required` | String | Device platform. Can be `'android'`, `'ios'` or `'chrome'`. |
| resource_id | Integer | Model object which will have the device |
| resource_type | String | Model name which will have the device, needs to be the same of class. If not passed, the first model will be selected |

`Request`

Header
```json
{
  "Content-Type": "application/json"
}
```
Body
```json
{
  "token": "804b56b7ab9cdf43fff540c5d93f3922aeaf65feb14f7ae88698b9b032a7a934",
  "platform": "android",
  "resource_id": 10,
  "resource_type": "Driver"
}
```

`Response` | `Status: 200`
```json
{
  "data": {
    "id": 1,
    "pushable_id": 10,
    "pushable_type": "Driver",
    "token": "804b56b7ab9cdf43fff540c5d93f3922aeaf65feb14f7ae88698b9b032a7a934",
    "platform": "android",
    "created_at": "2016-10-17T14:19:58.776Z",
    "updated_at": "2016-10-17T20:30:20.064Z"
  },
  "status": "success"
}
```

`Error` | `Status: 422`
```json
{
  "data": {
    "id": null,
    "token": null,
    "platform": null,
    "pushable_id": 10,
    "pushable_type": "Driver",
    "created_at": null,
    "updated_at": null
  },
  "errors": [
    "Token não pode ficar em branco",
    "Platform não pode ficar em branco"
  ],
  "status": "unprocessable_entity"
}
```

#### Delete a device
> /jera_push/v1/devices | `DELETE`

| Parameter |    Type    | Description |
|----------|------------|-------------|
| token | String | Target device which will be deleted |
| platform | String | Device platform. Can be `'android'`, `'ios'` or `'chrome'`. |

`Request`

Header
```json
{
  "Content-Type": "application/json"
}
```
Body
```json
{
  "token": "804b56b7ab9cdf43fff540c5d93f3922aeaf65feb14f7ae88698b9b032a7a934",
  "platform": "android"
}
```

`Response` | `Status: 200`
```json
{
  "data": {
    "id": 1,
    "token": "804b56b7ab9cdf43fff540c5d93f3922aeaf65feb14f7ae88698b9b032a7a934",
    "platform": "android",
    "pushable_id": 10,
    "pushable_type": "Driver",
    "created_at": "2016-10-17T14:19:58.776Z",
    "updated_at": "2016-10-17T20:30:20.064Z"
  },
  "status": "success"
}
```

`Error` | `Status: 404`
```
No Content
```
---
