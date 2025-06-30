// utils/EventBus.ets
export class EventBus {
  private static instance: EventBus = null;
  private listeners: { [eventName: string]: Array<(data?: any) => void> } = {};

  private constructor() {}

  static getInstance(): EventBus {
    if (!this.instance) {
      this.instance = new EventBus();
    }
    return this.instance;
  }

  on(eventName: string, callback: (data?: any) => void): void {
    if (!this.listeners[eventName]) {
      this.listeners[eventName] = [];
    }
    this.listeners[eventName].push(callback);
  }

  off(eventName: string, callback: (data?: any) => void): void {
    if (this.listeners[eventName]) {
      this.listeners[eventName] = this.listeners[eventName].filter(
        listener => listener !== callback
      );
    }
  }

  emit(eventName: string, data?: any): void {
    if (this.listeners[eventName]) {
      this.listeners[eventName].forEach(listener => listener(data));
    }
  }
}