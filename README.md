![Jera Logo](https://jera.com.br/images/logo-jera-light.svg)

JeraPush is a easy tool to work with push messages and firebase API.

It's composed for:
 * [Services](#sending-your-notifications): Services to send notifications.
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

## Warning
* Device registration in Firebase topics is disabled for now. Therefore, topic pushes are also temporarily disabled
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
  config.project_name = "YOUR_PROJECT_NAME"
  config.credentials_path = "YOUR_CREDENTIALS_PATH" #https://firebase.google.com/docs/cloud-messaging/migrate-v1?hl=pt-br#provide-credentials-manually


  ######################################################
  # Resource attribute showed in views                 #
  # IMPORTANT: All models need to have this attributes #
  # config.resource_attributes = [:email, :name]       #
  ######################################################

  # Topic default
  # You should put with your environment
  config.default_topic = 'jera_push_development'

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

## Sending your notifications

### Sending one push for one device

* Values inside of data need to be a string

```ruby
send_to_device = JeraPush::Services::SendToDeviceService.new(
  device: JeraPush::Device.last,
  title: 'Notification Title',
  body: 'Notification Body', 
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' }
)
send_to_device.call
```
* If you need to specify some android os ios configuration you can pass a `android` or `ios` hash like this:
```ruby
send_to_device = JeraPush::Services::SendToDeviceService.new(
  device: JeraPush::Device.last, 
  title: 'Notification Title',
  body: 'Notification Body', 
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' }, 
  android: {}, 
  ios: {}
)
send_to_service.call
```

* The default config to Android is: 
  `{ priority: 'high'}`
* And for iOS is:
```json
{
  headers: {
    'apns-priority': '5'
  },
  payload: {
    aps: {
      'content-available': 1
    }
  }
}
```
- So, if you send some params in ios hash, the default config is will be overridden
- And if you send android params, they has been merged with the default params
* Android config: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#AndroidConfig
* iOS config: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#ApnsConfig

### Sending one push for many devices

```ruby
send_to_device = JeraPush::Services::SendToDevicesService.new(
  devices: JeraPush::Device.where('id < 10'),
  title: 'Notification Title',
  body: 'Notification Body', 
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' }
)
send_to_device.call
```
* If you need to specify some android os ios configuration you can pass a `android` or `ios` hash like this:
```ruby
send_to_device = JeraPush::Services::SendToDevicesService.new(
  device: JeraPush::Device.where('id < 10'), 
  title: 'Notification Title', 
  body: 'Notification Body', 
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' }, 
  android: {}, 
  ios: {}
)
send_to_device.call
```

---
## Firebase::Client
> Class responsible for interact with Firebase.

### Methods
* send_to_device
* add_device_to_topic
* add_devices_to_topic
* remove_device_from_topic


### Device registration in Firebase topics is disabled for now. Therefore, topic pushes are also temporarily disabled

#### Initialize the firebase client
```ruby
client = JeraPush::Firebase::Client.new
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

<<<<<<< HEAD
### Methods
* send_broadcast `static`
* send_to `static`
* send_to_devices
* send_to_device

#### `send_broadcast(content: {})`
Sends message to all registered devices.

```ruby
JeraPush::Message.send_broadcast(content: { body: 'Hello World', title: 'Hey' })
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
=======
>>>>>>> develop

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

## Traduções (Fazendo os dois as traduções irão funcionar corretamente!)

> Para o admin ficar com as traduções corretas, adicione as traduções do do modelo e dos atributos do modelo
> Caso o `resource_attributes` tenha campos diferentes de `name` ou `email`, adicione no arquivo `jera_push.pt-BR.yml`, dentro de `admin.attributes`, exemplos logo abaixo.


### Tradução do nome do modelo e atributos

```yml
  activerecord:
    attributes:
      user:
        id: '#'
        name: Nome
        email: E-mail
    models:
      user: Usuário
```

### Tradução de atributos para o admin jera_push

```yml
  jera_push:
    admin:
      attributes:
        phone: "Telefone"
        cpf: "CPF"
```
