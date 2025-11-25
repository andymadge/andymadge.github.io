# Bundle Setup Guide for Multi-Architecture Development

This document explains how to set up and maintain bundle dependencies when working across both Intel and Apple Silicon Macs.

## The Problem

Nokogiri (and other gems with native extensions) have platform-specific builds. When you run `bundle install`, bundler may install the wrong architecture version, causing this error:

```
LoadError: cannot load such file -- nokogiri/nokogiri
```

## Quick Fix

### On Apple Silicon (ARM64) Macs

If you get the nokogiri error on Apple Silicon:

```bash
# Remove the x86_64 version
rm -rf vendor/bundle/ruby/2.6.0/gems/nokogiri-*-x86_64-darwin
rm -f vendor/bundle/ruby/2.6.0/specifications/nokogiri-*-x86_64-darwin.gemspec

# Install nokogiri compiled for ARM64
gem install nokogiri -v '1.13.10' \
  --install-dir vendor/bundle/ruby/2.6.0 \
  --platform=ruby \
  --no-document \
  -- --use-system-libraries

# Test Jekyll
bundle exec jekyll serve
```

### On Intel (x86_64) Macs

On Intel Macs, the standard bundle install should work:

```bash
bundle install --path vendor/bundle
bundle exec jekyll serve
```

If you encounter issues:

```bash
# Clean and reinstall
rm -rf vendor/bundle
bundle install --path vendor/bundle
```

## Switching Between Machines

When you switch between Intel and Apple Silicon Macs:

### Option 1: Clean Install (Recommended)

```bash
# On the new machine, remove vendor/bundle
rm -rf vendor/bundle .bundle

# Reinstall for current architecture
bundle install --path vendor/bundle

# On Apple Silicon, apply the nokogiri fix if needed (see above)
```

### Option 2: Keep Separate Bundles

Add vendor/bundle to .gitignore (it already should be) and maintain separate bundles on each machine.

## Common Commands

```bash
# Install dependencies
bundle install --path vendor/bundle

# Update dependencies
bundle update

# Run Jekyll development server
bundle exec jekyll serve

# Clean bundle cache
bundle clean --force
```

## Long-Term Solution

Consider using a Ruby version manager with native ARM64 Ruby:

### Using rbenv

```bash
# Install rbenv via Homebrew
brew install rbenv

# Install Ruby
rbenv install 3.2.2
rbenv local 3.2.2

# Reinstall bundler and gems
gem install bundler
bundle install
```

### Using asdf

```bash
# Install asdf via Homebrew
brew install asdf

# Add Ruby plugin
asdf plugin add ruby

# Install Ruby
asdf install ruby 3.2.2
asdf local ruby 3.2.2

# Reinstall bundler and gems
gem install bundler
bundle install
```

## Troubleshooting

### Error: "cannot load such file -- nokogiri/nokogiri"

You have the wrong architecture version installed. See "Quick Fix" above for your architecture.

### Error: "Bundler requires sudo access"

The path configuration was lost. Run:

```bash
bundle install --path vendor/bundle
```

### Check which nokogiri versions are installed

```bash
ls -la vendor/bundle/ruby/2.6.0/gems/ | grep nokogiri
```

You should see either:
- `nokogiri-1.13.10` (compiled from source, works on both)
- `nokogiri-1.13.10-x86_64-darwin` (Intel only)
- `nokogiri-1.13.10-arm64-darwin` (Apple Silicon only, rare for old versions)

### Check your system architecture

```bash
uname -m
# arm64 = Apple Silicon
# x86_64 = Intel
```

### Force recompile all native gems

```bash
bundle pristine
```

## Notes

- The system Ruby (2.6.x) is deprecated. Consider upgrading to Ruby 3.x using rbenv or asdf.
- The `vendor/bundle` directory is gitignored and machine-specific.
- The `Gemfile.lock` tracks gem versions but may need platform-specific entries.
- The warning "To use retry middleware with Faraday v2.0+, install faraday-retry gem" is harmless.
