# tool macros
CC := g++
CCFLAGS := -Iincludes/
PACKAGE = `pkg-config --cflags --libs gtk+-3.0`
LIBS = `pkg-config --libs gtk+-3.0`
DBGFLAGS := -g
LDFLAGS :=
CCOBJFLAGS := $(CCFLAGS) -c
ARCH :=

# path macros
BIN_PATH := build-$(ARCH)/bin
OBJ_PATH := build-$(ARCH)/obj
SRC_PATH := src
DBG_PATH := build-$(ARCH)/debug

# compile macros
TARGET_NAME := GTK-Example
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*) $(addprefix $(x)/*,.css)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(filter-out %.css, $(SRC))))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(filter-out %.css, $(SRC))))))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
					$(OBJ_DEBUG)

CLEAN_LIST := $(TARGET) \
				$(TARGET_DEBUG) \
				$(DISTCLEAN_LIST)

# default rule
default: makedir all

# non-phony targets
$(TARGET): $(OBJ)
	$(CC) $(CCFLAGS) -o $@ $(OBJ) $(LDFLAGS) $(LIBS)
	cp $(SRC_PATH)/demo.ui $(BIN_PATH)
	
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(CCOBJFLAGS) -o $@ $< $(PACKAGE)

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(CCOBJFLAGS) $(DBGFLAGS) -o $@ $< $(PACKAGE)

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CC) $(CCFLAGS) $(DBGFLAGS) $(OBJ_DEBUG) -o $@ $(LDFLAGS) $(LIBS)
	cp $(SRC_PATH)/demo.ui $(DBG_PATH)

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH)

.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)
