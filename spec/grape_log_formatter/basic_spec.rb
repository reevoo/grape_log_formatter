require "spec_helper"

describe GrapeLogFormatter::Basic do
  let(:severity) { "INFO" }
  let(:time) { Time.local(2016, 5, 6, 18, 20) }

  let(:result) { GrapeLogFormatter::Basic.new.call(severity, time, nil, data) }
  let(:pid) { $PROCESS_ID }
  let(:uniq_id) { "a345dv" }
  let(:exception) do
    e = StandardError.new("Application failed")
    e.set_backtrace(%w(file_1 file_2))
    e
  end

  before do
    allow(SecureRandom).to receive(:hex) { uniq_id }
  end

  context "data is a string" do
    let(:data) { "Warning message" }

    it "contain time, severity and data string" do
      expect(result).to eq <<-STR
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- Warning message

STR
    end
  end

  context "data is an exception" do
    let(:data) { exception }

    it "contain time, severity and exception title and backtrace" do
      expect(result).to eq <<-STR
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- Application failed
\tfile_1
\tfile_2

      STR
    end
  end

  context "data is hash" do
    context "simple request data" do
      let(:data) do
        {
          status: 200,
          time:  { total: 18.18, db: 0.0, view: 18.18 },
          method: "POST",
          path:  "/api/v1/locks",
          params: { "content_id" => "150d33f4-d9a7-4e21-b425-067c638d1ffe" },
          ip: "127.0.0.1",
          ua: nil,
        }
      end

      it "contain time, severity, method, status, path, params, pid, ip and time" do
        expect(result).to eq <<-STR
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- POST 200  /api/v1/locks
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- Params: {"content_id":"150d33f4-d9a7-4e21-b425-067c638d1ffe"}
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- IP: 127.0.0.1 | Total: 18.18 DB: 0.0 View: 18.18

        STR
      end
    end

    context "only exception is logged" do
      let(:data) do
        {
          staus: 403,
          exception: exception,
          tags: "rescued_exception",
        }
      end

      it "contain time, severity, pid, exception title, backtrace" do
        expect(result).to eq <<-STR
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- rescued_exception
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- IP: - | Total: - DB: - View: -
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- Application failed
\tfile_1
\tfile_2

        STR
      end
    end

    context "exception is logged and env is paased" do
      let(:data) do
        {
          staus: 403,
          exception: exception,
          tags: "rescued_exception",
          env: {
            "REMOTE_ADDR" => "127.0.0.1",
            "PATH_INFO" => "/api/v1/locks/cce8e905",
            "rack.routing_args" => {
              id: "cce8e905",
            },
          },
        }
      end

      it "contain time, severity, pid, exception title, backtrace" do
        expect(result).to eq <<-STR
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- rescued_exception /api/v1/locks/cce8e905
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- Params: {"id":"cce8e905"}
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- IP: 127.0.0.1 | Total: - DB: - View: -
[2016-05-06 18:20:00 +0200] <a345dv:##{pid}> INFO -- Application failed
\tfile_1
\tfile_2

        STR
      end
    end
  end
end
