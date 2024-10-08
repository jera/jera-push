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

You need to create a Account Service on google cloud, with editor permission or administrator. Flow this doc: https://cloud.google.com/iam/docs/service-accounts-create?hl=pt-br

That command will create the necessary migrations and the initialize file. The file will be like this:
```ruby
#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  # Change this for every new model
  config.resources_name = ["<%= file_name.classify %>"]
  # You need to create a Account Service on google cloud, with editor permission or administrator. Flow this doc: https://cloud.google.com/iam/docs/service-accounts-create?hl=pt-br
  config.project_id = "YOUR_PROJECT_ID" # inside of the account service json
  config.credentials_path = Rails.root.join("YOUR_CREDENTIALS_NAME").to_path #https://firebase.google.com/docs/cloud-messaging/migrate-v1?hl=pt-br#provide-credentials-manually
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

* Firs of all, create your device"

```ruby
# considering your push is to a User model

token = "DEVICE_TOKEN_GENERATED_BY_APP"
pushable = User.last
platform = :android # enum [:android, :ios]
JeraPush::Device.create(token: token, platform: platform, pushable: pushable)
```

### Sending one push for one device

* Values inside of data need to be a string

```ruby
push_body = JeraPush::PushBody.new(
  title: 'Title', 
  body: 'Body', 
  device: JeraPush::Device.last,
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' },
  analytics_label: 'my_analytics_label'
)
send_to_device = JeraPush::Services::SendToDeviceService.new(push: push)
send_to_device.call
```

* If you need to specify some android os ios configuration you can pass a `android` or `ios` hash like this:
- `ios_config` and `android_config` have a default value, so if you don't need it, you don't need to pass a value like the previous examples
```ruby
# REF https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#AndroidConfig
android_config = JeraPush::AndroidConfig.new(priority: 'high')
# REF https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#ApnsConfig
ios_config = JeraPush::AppleConfig.new(apns_priority: '3')
push_body = JeraPush::PushBody.new(
  title: 'Title', 
  body: 'Body', 
  device: JeraPush::Device.last,
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' },
  analytics_label: 'my_analytics_label',
  android_config: android_config,
  ios_config: ios_config
)
send_to_device = JeraPush::Services::SendToDeviceService.new(
  push: push_body
)
send_to_device.call
```

* The default config to Android is: 
  `{ priority: 'high'}`
* And for iOS is:
```
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

### Sending one push for many devices

```ruby
push_body = JeraPush::PushBody.new(
  title: 'Title', 
  body: 'Body', 
  devices: JeraPush::Device.where('id < 10'),
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' },
  analytics_label: 'my_analytics_label'
)
send_to_devices = JeraPush::Services::SendToDevicesService.new(push: push)
send_to_devices.call
```
* If you need to specify some android os ios configuration you can pass a `android` or `ios` hash like this:
```ruby
# REF https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#AndroidConfig
android_config = JeraPush::AndroidConfig.new(priority: 'high')
# REF https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages?hl=pt-br#ApnsConfig
ios_config = JeraPush::AppleConfig.new(apns_priority: '3')
push_body = JeraPush::PushBody.new(
  title: 'Title', 
  body: 'Body', 
  devices: JeraPush::Device.where('id < 10'),
  data: { kind: :some_kind_to_something_in_app, resource_id: '3' },
  analytics_label: 'my_analytics_label',
  android_config: android_config,
  ios_config: ios_config
)
send_to_devices = JeraPush::Services::SendToDevicesService.new(
  push: push_body
)
send_to_devices.call
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
