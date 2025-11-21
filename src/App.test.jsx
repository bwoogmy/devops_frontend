import { describe, it, expect } from 'vitest'

describe('App smoke tests', () => {
  it('should pass basic sanity check', () => {
    expect(1 + 1).toBe(2)
  })
  
  it('should have correct environment', () => {
    expect(import.meta.env).toBeDefined()
  })
})
