require 'spec_helper'

RSpec.describe Wirecard::Callback do
  let(:fingerprinter) { Wirecard::Fingerprint::Sha512.new(params, implicit_fingerprint_order) }
  let(:params) { { 'parameterKey1' => 'parameterValue1',
                   'parameterKey2' => 'parameterValue2' }.merge!(additional_params) }
  let(:additional_params) { {} }
  let(:implicit_fingerprint_order) { nil }
  
  describe '#fingerprinted_params' do
    subject { fingerprinter.fingerprinted_params }
    
    context 'when no implicit_fingerprint_order is given' do
      let(:implicit_fingerprint_order) { nil }
      
      it { is_expected.to eq params.merge({
        "requestFingerprint" => "5b158abcb10055cc9a700a871676559b5444cd9b9e7d6aebb9ae2783dd1230bdb46b6c2db1bbefe816757762b281aa44fbc7b73dcfad115d9d276582e04f603b",
        "requestFingerprintOrder" => "parameterKey1,parameterKey2,requestFingerprintOrder,secret"
      }) }
    end
    
    context 'when implicit_fingerprint_order is set' do
      let(:implicit_fingerprint_order) { ['parameterKey2', 'parameterKey1', 'secret'] }
      
      it { is_expected.to eq params.merge({
        "requestFingerprint" => "8c558d1efb1fdbb768c92774c622e0b38b6fe1ff0c63ee37513a1bfa138df33c868962acf1e255fb0513adfd23019343412d092e1e3fdfe3ba178bd91e5d9216"
      }) }
    end
  end
  
  describe '#request_fingerprint_order' do
    subject { fingerprinter.send(:request_fingerprint_order) }
    
    it { is_expected.to eq 'parameterKey1,parameterKey2,requestFingerprintOrder,secret' }
  end
  
  describe '#fingerprint_string' do
    subject { fingerprinter.send(:fingerprint_string) }
    
    context 'when no implicit_fingerprint_order is given' do
      let(:implicit_fingerprint_order) { nil }
      
      context 'when requestFingerprintOrder is set within parameters' do
        let(:additional_params) { {'requestFingerprintOrder' => 'parameterKey1,parameterKey2,requestFingerprintOrder,secret'} }
        
        it { is_expected.to eq 'parameterValue1parameterValue2parameterKey1,parameterKey2,requestFingerprintOrder,secretB8AKTPWBRMNBV455FG6M2DANE99WU2' }
      end
      
      context 'when responseFingerprintOrder is set within parameters' do
        let(:additional_params) { {'responseFingerprintOrder' => 'parameterKey2,parameterKey1,secret,responseFingerprintOrder'} }
        
        it { is_expected.to eq 'parameterValue2parameterValue1B8AKTPWBRMNBV455FG6M2DANE99WU2parameterKey2,parameterKey1,secret,responseFingerprintOrder' }
      end
      
      context 'when no order is given in the params' do
        it { expect{ subject }.to raise_error(Wirecard::Fingerprint::NoFingerprintOrderGivenError) }
      end
    end
    
    context 'when implicit_fingerprint_order is set' do
      let(:implicit_fingerprint_order) { ['parameterKey2', 'parameterKey1', 'secret'] }
      
      it { is_expected.to eq 'parameterValue2parameterValue1B8AKTPWBRMNBV455FG6M2DANE99WU2' }
    end
    
    
  end
  
end