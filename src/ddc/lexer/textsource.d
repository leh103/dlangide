module ddc.lexer.textsource;

private import std.utf;
private import std.array;

/**
* Source file information.
* Even if contains only file name, it's better to use it instead of string - object reference size is twice less than array ref.
*/
class SourceFile {
	protected string _file;
	public @property string filename() { return _file; }
    public this(string filename) {
        _file = filename;
    }
}

/// source lines for tokenizer
interface SourceLines {
    /// source file
	@property SourceFile file();
    /// last read line
	@property uint line();
    /// source encoding
	//@property EncodingType encoding() { return _encoding; }
    /// error code
	@property int errorCode();
    /// error message
	@property string errorMessage();
    /// error line
	@property int errorLine();
    /// error position
	@property int errorPos();

    /// read line, return null if EOF reached or error occured
    dchar[] readLine();
}

/// Simple text source based on array
class ArraySourceLines : SourceLines {
    protected SourceFile _file;
    protected uint _line;
    protected uint _firstLine;
    protected dstring[] _lines;
    static protected dchar[] _emptyLine = ""d.dup;

    this() {
    }

    this(dstring[] lines, SourceFile file, uint firstLine = 0) {
        init(lines, file, firstLine);
    }

    this(string code, string filename) {
        _lines = (toUTF32(code)).split("\n");
        _file = new SourceFile(filename);
    }

    void close() {
        _lines = null;
        _line = 0;
        _firstLine = 0;
        _file = null;
    }

    void init(dstring[] lines, SourceFile file, uint firstLine = 0) {
        _lines = lines;
        _firstLine = firstLine;
        _line = 0;
        _file = file;
    }

    bool reset(int line) {
        _line = line;
        return true;
    }

    /// source file
    override @property SourceFile file() { return _file; }
    /// last read line
	override @property uint line() { return _line; }
    /// source encoding
	//@property EncodingType encoding() { return _encoding; }
    /// error code
	override @property int errorCode() { return 0; }
    /// error message
	override @property string errorMessage() { return ""; }
    /// error line
	override @property int errorLine() { return 0; }
    /// error position
	override @property int errorPos() { return 0; }

    /// read line, return null if EOF reached or error occured
    override dchar[] readLine() {
        if (_line < _lines.length) {
            if (_lines[_line])
                return cast(dchar[])_lines[_line++];
            _line++;
            return _emptyLine;
        }
        return null; // EOF
    }
}
