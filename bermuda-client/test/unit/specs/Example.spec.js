import Vue from 'vue'
import Example from '@/components/Example'

describe('Example.vue', () => {
  it('should render correct contents', () => {
    const Constructor = Vue.extend(Example)
    const vm = new Constructor().$mount()
    expect(vm.$el.querySelector('.example h1').textContent)
      .toEqual('Hello Example Component')
  })
})
