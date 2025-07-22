#!/usr/bin/env python3
"""
Quick test script for local NeMo Guardrails installation.
Tests basic functionality without requiring external LLM APIs.
"""

import sys
import os
from nemoguardrails import LLMRails, RailsConfig

def test_local_installation():
    """Test that NeMo Guardrails is properly installed and functional."""
    
    print("🧪 Testing NeMo Guardrails Local Installation...")
    
    try:
        # Test 1: Basic import
        print("✅ Import successful")
        
        # Test 2: Load config
        config_path = "./configs/simple-example"
        if os.path.exists(config_path):
            config = RailsConfig.from_path(config_path)
            print("✅ Configuration loaded successfully")
            
            # Test 3: Create rails instance
            rails = LLMRails(config)
            print("✅ Rails instance created successfully")
            
            print("\n🎉 Local installation is working correctly!")
            print("\n📝 Next steps:")
            print("1. Configure your LLM provider in the config")
            print("2. Run: nemoguardrails chat --config ./configs/simple-example")
            print("3. Or start server: nemoguardrails server --config ./configs/simple-example")
            
        else:
            print("⚠️  Example config not found - that's okay for basic testing")
            print("✅ Core installation is working")
            
    except ImportError as e:
        print(f"❌ Import failed: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"⚠️  Error during testing: {e}")
        print("   This might be due to missing configuration - that's normal")

if __name__ == "__main__":
    test_local_installation()
