// Register.ets
import router from '@ohos.router';
import { registerUser } from '../utils/UserData';

@Entry
@Component
struct Register {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State showSuccess: boolean = false;
  @State passwordVisible: boolean = false;
  @State confirmPasswordVisible: boolean = false;
  @State errorMessage: string = '';

  build() {
    Column() {
      if (!this.showSuccess) {
        // 错误消息提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#FF0000')
            .margin({ bottom: 20 })
        }

        // 注册表单
        Column() {
          // 用户名输入
          Column() {
            Text('用户名')
              .fontSize(18)
              .margin({ bottom: 5 })

            TextInput({
              text: this.username,
              placeholder: '请输入用户名'
            })
              .onChange((value: string) => {
                this.username = value;
                this.errorMessage = '';
              })
              .type(InputType.Normal)
              .width('100%')
              .height(50)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 20 })
          }
          .width('80%')

          // 密码输入
          Column() {
            Text('密码')
              .fontSize(18)
              .margin({ bottom: 5 })

            TextInput({
              text: this.password,
              placeholder: '请输入密码'
            })
              .onChange((value: string) => {
                this.password = value;
                this.errorMessage = '';
              })
              .type(this.passwordVisible ? InputType.Normal : InputType.Password)
              .width('100%')
              .height(50)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 10 })

            // 密码可见性切换
            Row() {
              Toggle({ type: ToggleType.Checkbox, isOn: this.passwordVisible })
                .onChange((isOn: boolean) => {
                  this.passwordVisible = isOn;
                })
                .size({ width: 24, height: 24 })

              Text('显示密码')
                .fontSize(14)
                .margin({ left: 5 })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .margin({ bottom: 20 })
          }
          .width('80%')

          // 确认密码输入
          Column() {
            Text('确认密码')
              .fontSize(18)
              .margin({ bottom: 5 })

            TextInput({
              text: this.confirmPassword,
              placeholder: '请确认密码'
            })
              .onChange((value: string) => {
                this.confirmPassword = value;
                this.errorMessage = '';
              })
              .type(this.confirmPasswordVisible ? InputType.Normal : InputType.Password)
              .width('100%')
              .height(50)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .margin({ bottom: 10 })

            // 确认密码可见性切换
            Row() {
              Toggle({ type: ToggleType.Checkbox, isOn: this.confirmPasswordVisible })
                .onChange((isOn: boolean) => {
                  this.confirmPasswordVisible = isOn;
                })
                .size({ width: 24, height: 24 })

              Text('显示密码')
                .fontSize(14)
                .margin({ left: 5 })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .margin({ bottom: 50 })
          }
          .width('80%')

          // 注册按钮
          Button('注册', { type: ButtonType.Capsule })
            .onClick(async () => {
              if (!this.username.trim() || !this.password.trim() || !this.confirmPassword.trim()) {
                this.errorMessage = '请填写完整信息';
                return;
              }

              if (this.password !== this.confirmPassword) {
                this.errorMessage = '两次输入的密码不一致';
                return;
              }

              try {
                // 调用注册函数
                const isRegistered = registerUser(this.username, this.password);
                if (isRegistered) {
                  // 注册成功
                  this.showSuccess = true;
                } else {
                  this.errorMessage = '用户已存在，请选择其他用户名';
                }
              } catch (err) {
                console.error('注册错误:', err);
                this.errorMessage = '注册失败，请稍后再试';
              }
            })
            .width(150)
            .height(50)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 注册成功提示
        Column() {
          Text('注册成功！')
            .fontSize(24)
            .margin({ bottom: 30 })

          Button('返回登录', { type: ButtonType.Capsule })
            .onClick(() => {
              router.back();
            })
            .width(150)
            .height(50)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(20)
  }
}